#' Validate a period unit
#'
#' @param unit A period unit string.
#' @return The validated `unit`, or an error.
#' @keywords internal
#' @noRd
validate_period_unit <- function(unit) {
  rlang::arg_match0(
    unit,
    values = c("week", "month", "quarter", "year"),
    arg_nm = "unit"
  )
}

#' Business days remaining between a cutoff and a period end
#'
#' Vectorized count of business days in the half-open interval `(from, to]`,
#' clamped so [qlcal::businessDaysBetween()] never receives `from > to`, and
#' masked to `0L` whenever the cutoff has already reached or passed the end.
#'
#' @param from Cutoff date(s) (the reference position, e.g. `as_of`).
#' @param to Period end date(s).
#' @param calendar (character) A QuantLib calendar id.
#' @return An integer vector of business days remaining.
#' @keywords internal
#' @noRd
n_bizdays_remaining <- function(from, to, calendar) {
  from <- as.Date(from)
  to <- as.Date(to)

  n <- max(length(from), length(to))
  from <- rep_len(from, n)
  to <- rep_len(to, n)

  # qlcal errors on NA (and out-of-range) dates, so substitute a safe in-range
  # placeholder for NA endpoints and restore NA in the result afterwards.
  na_mask <- is.na(from) | is.na(to)
  placeholder <- as.Date("2000-01-01")
  from[na_mask] <- placeholder
  to[na_mask] <- placeholder

  # clamp so qlcal never sees from > to; the mask below fixes those elements
  from_clamped <- pmin(from, to)

  remaining <- bizdays_between(
    from = from_clamped,
    to = to,
    calendar = calendar,
    include_first = FALSE,
    include_last = TRUE
  )

  remaining <- as.integer(remaining)
  remaining[from >= to] <- 0L
  remaining[na_mask] <- NA_integer_
  remaining
}

#' Start or end date of the period containing each date
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' `period_start_date()` and `period_end_date()` return the first and last
#' *calendar* day of the period containing each `date`. They are thin, coercing,
#' vectorized wrappers around [lubridate::floor_date()] and
#' [lubridate::ceiling_date()] that always return a [Date] (never a datetime)
#' and validate `unit`.
#'
#' The returned dates are always canonical calendar boundaries. Business-day
#' calendars are used only to *judge completeness* (see [period_is_complete()]),
#' never to compute a boundary date.
#'
#' @param date A vector of dates (Date or coercible with [lubridate::as_date()]).
#' @param unit Period size, one of `"week"`, `"month"`, `"quarter"`,
#'   or `"year"`.
#' @param week_start Integer 1-7 giving the first day of the week (only used when
#'   `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`, so the
#'   package defers to the session's lubridate week convention.
#' @return A [Date] vector the same length as `date`.
#' @seealso [period_is_complete()], [last_complete_period_end()]
#' @name period_bounds
#' @examples
#' period_start_date(as.Date("2025-05-14"), "month") # 2025-05-01
#' period_end_date(as.Date("2025-05-14"), "month") # 2025-05-31
#' period_end_date(as.Date("2025-05-14"), "quarter") # 2025-06-30
NULL

#' @rdname period_bounds
#' @export
period_start_date <- function(date, unit = "month",
                              week_start = getOption("lubridate.week.start", 7)) {
  unit <- validate_period_unit(unit)
  date <- lubridate::as_date(date)
  as.Date(lubridate::floor_date(date, unit = unit, week_start = week_start))
}

#' @rdname period_bounds
#' @export
period_end_date <- function(date, unit = "month",
                            week_start = getOption("lubridate.week.start", 7)) {
  unit <- validate_period_unit(unit)
  date <- lubridate::as_date(date)
  ceiling <- lubridate::ceiling_date(
    date,
    unit = unit,
    week_start = week_start,
    change_on_boundary = TRUE
  )
  as.Date(ceiling) - 1L
}

#' Is the period containing each date complete as of a cutoff?
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' For each date in `date`, tests whether the period containing it is complete
#' as of `as_of` (typically `max(order_date)` or a report end date). A period is
#' complete once no business days remain after `as_of` up to and including the
#' period end, evaluated in `calendar`.
#'
#' Choosing `calendar` selects the completeness policy:
#' \itemize{
#'   \item `"WeekendsOnly"` (default) treats Mon-Fri as working days with no
#'     holidays -- a period is complete once only weekends remain.
#'   \item A national calendar such as `"UnitedStates"` additionally treats
#'     holidays as non-working, giving holiday-accurate completeness.
#'   \item `"Null"` treats every calendar day as a working day, so completeness
#'     reduces to "every calendar day of the period has elapsed"
#'     (`period_end_date(date) <= as_of`).
#' }
#' See [qlcal::calendars] for valid ids.
#'
#' @param date A vector of dates (Date or coercible with [as.Date()]); each value
#'   identifies the period to test.
#' @param unit Period size, one of `"week"`, `"month"`, `"quarter"`,
#'   or `"year"`.
#' @param as_of Reference cutoff date (Date or coercible), length 1 or the length
#'   of `date`. Defaults to [Sys.Date()].
#' @param calendar (character) A QuantLib calendar id (see [qlcal::calendars]).
#'   Defaults to `"WeekendsOnly"`.
#' @param week_start Integer 1-7 giving the first day of the week (only used when
#'   `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.
#' @return A logical vector the same length as `date`.
#' @seealso [filter_complete_periods()], [last_complete_period_end()],
#'   [scale_alpha_logical()], [period_end_date()]
#' @export
#' @examples
#' # As of 2025-05-30 (a Friday), April and May are complete under the
#' # weekends-only calendar -- May's only remaining day, the 31st, is a Saturday --
#' # but June is not. Returns c(TRUE, TRUE, FALSE).
#' period_is_complete(
#'   as.Date(c("2025-04-15", "2025-05-15", "2025-06-15")),
#'   unit = "month",
#'   as_of = as.Date("2025-05-30")
#' )
#'
#' # Pure calendar-day semantics: May is not complete until 2025-05-31 elapses.
#' period_is_complete(
#'   as.Date("2025-05-15"),
#'   as_of = as.Date("2025-05-30"),
#'   calendar = "Null"
#' )
period_is_complete <- function(date, unit = "month", as_of = Sys.Date(),
                               calendar = "WeekendsOnly",
                               week_start = getOption("lubridate.week.start", 7)) {
  unit <- validate_period_unit(unit)
  as_of <- as.Date(as_of)
  end <- period_end_date(date, unit = unit, week_start = week_start)

  if (!length(as_of) %in% c(1L, length(end))) {
    cli::cli_abort(c(
      "{.arg as_of} must be length 1 or the same length as {.arg date}.",
      "x" = "{.arg as_of} has length {length(as_of)}; {.arg date} has length {length(end)}."
    ))
  }

  n_bizdays_remaining(from = as_of, to = end, calendar = calendar) == 0L
}

#' Keep only rows whose period is complete as of a cutoff
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' Filters `data` to the rows whose period (per [period_is_complete()]) is
#' complete as of `as_of`. Useful for dropping the in-progress trailing period
#' from a summary or year-over-year comparison.
#'
#' @param data A data frame.
#' @param date_col <[`data-masked`][dplyr::dplyr_data_masking]> The date column
#'   whose period completeness is tested.
#' @param unit Period size, one of `"week"`, `"month"`, `"quarter"`,
#'   or `"year"`.
#' @param as_of Reference cutoff date, a single Date (or coercible). Defaults to
#'   `NULL`, in which case it is set to the maximum of `date_col` so completeness
#'   is judged against how current the data actually is. An explicit `as_of`
#'   *earlier* than the maximum of `date_col` is an error, because it would drop
#'   periods the data demonstrably completes; use [period_is_complete()] directly
#'   for point-in-time completeness.
#' @param calendar (character) A QuantLib calendar id (see [qlcal::calendars]).
#'   Defaults to `"WeekendsOnly"`.
#' @param week_start Integer 1-7 giving the first day of the week (only used when
#'   `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.
#' @return `data` filtered to rows in complete periods.
#' @seealso [period_is_complete()]
#' @export
#' @examples
#' df <- data.frame(day = seq(as.Date("2025-04-01"), as.Date("2025-06-12"), by = "day"))
#' # as_of defaults to max(day) = 2025-06-12, so the partial June is dropped
#' nrow(filter_complete_periods(df, day, unit = "month"))
filter_complete_periods <- function(data, date_col, unit = "month", as_of = NULL,
                                    calendar = "WeekendsOnly",
                                    week_start = getOption("lubridate.week.start", 7)) {
  unit <- validate_period_unit(unit)

  dates <- as.Date(dplyr::pull(data, {{ date_col }}))
  # NA when there are no non-missing dates; rows then all read incomplete (NA)
  data_max <- if (all(is.na(dates))) as.Date(NA) else max(dates, na.rm = TRUE)

  if (is.null(as_of)) {
    as_of <- data_max
  } else {
    as_of <- as.Date(as_of)
    if (length(as_of) != 1L) {
      cli::cli_abort(c(
        "{.arg as_of} must be a single date, or {.code NULL} to use the maximum of {.arg date_col}.",
        "x" = "{.arg as_of} has length {length(as_of)}."
      ))
    }
    if (!is.na(data_max) && as_of < data_max) {
      cli::cli_abort(c(
        "{.arg as_of} ({.val {as_of}}) is earlier than the maximum of {.arg date_col} ({.val {data_max}}).",
        "x" = "This would drop periods that are demonstrably complete in the data.",
        "i" = "Use {.fn period_is_complete} directly for point-in-time completeness."
      ))
    }
  }

  dplyr::filter(
    data,
    period_is_complete(
      {{ date_col }},
      unit = unit,
      as_of = as_of,
      calendar = calendar,
      week_start = week_start
    )
  )
}

#' Boundary of the most recent complete period as of a cutoff
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' `last_complete_period_end()` returns the (canonical calendar) end date of the
#' most recent period that is complete as of `as_of`; `last_complete_period_start()`
#' returns that period's start date. Completeness is judged with
#' [period_is_complete()], so `calendar` selects the policy exactly as it does
#' there.
#'
#' @param as_of Reference cutoff date(s) (Date or coercible). Defaults to
#'   [Sys.Date()].
#' @param unit Period size, one of `"week"`, `"month"`, `"quarter"`,
#'   or `"year"`.
#' @param calendar (character) A QuantLib calendar id (see [qlcal::calendars]).
#'   Defaults to `"WeekendsOnly"`.
#' @param week_start Integer 1-7 giving the first day of the week (only used when
#'   `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.
#' @return A [Date] vector the same length as `as_of`.
#' @seealso [period_is_complete()], [period_end_date()]
#' @name last_complete_period
#' @examples
#' # 2025-05-30 falls in Q2 2025, which is still in progress, so the most recent
#' # complete quarter ends 2025-03-31.
#' last_complete_period_end(as.Date("2025-05-30"), unit = "quarter")
#' last_complete_period_start(as.Date("2025-05-30"), unit = "quarter")
NULL

#' @rdname last_complete_period
#' @export
last_complete_period_end <- function(as_of = Sys.Date(), unit = "month",
                                     calendar = "WeekendsOnly",
                                     week_start = getOption("lubridate.week.start", 7)) {
  unit <- validate_period_unit(unit)
  as_of <- as.Date(as_of)

  end_current <- period_end_date(as_of, unit = unit, week_start = week_start)
  # canonical end of the immediately prior period
  end_prior <- period_start_date(as_of, unit = unit, week_start = week_start) - 1L

  complete_now <- period_is_complete(
    as_of,
    unit = unit,
    as_of = as_of,
    calendar = calendar,
    week_start = week_start
  )

  # dplyr::if_else preserves the Date class (base ifelse would strip it)
  dplyr::if_else(complete_now, end_current, end_prior)
}

#' @rdname last_complete_period
#' @export
last_complete_period_start <- function(as_of = Sys.Date(), unit = "month",
                                       calendar = "WeekendsOnly",
                                       week_start = getOption("lubridate.week.start", 7)) {
  end <- last_complete_period_end(
    as_of,
    unit = unit,
    calendar = calendar,
    week_start = week_start
  )
  period_start_date(end, unit = unit, week_start = week_start)
}

#' A ggplot2 alpha scale for complete versus incomplete periods
#'
#' @description
#' `r lifecycle::badge("experimental")`
#'
#' A manual alpha scale mapping `FALSE`/`TRUE` to two opacity levels, with the
#' guide hidden. Pairs with [period_is_complete()] to fade the in-progress
#' period in bar or column charts, e.g.
#' `ggplot2::aes(alpha = period_is_complete(date, as_of = cutoff))`.
#'
#' @param false_alpha Alpha applied to `FALSE` (incomplete) values. Defaults to
#'   0.5.
#' @param true_alpha Alpha applied to `TRUE` (complete) values. Defaults to 1.
#' @return A ggplot2 scale object.
#' @seealso [period_is_complete()]
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(
#'   month = as.Date(c("2025-04-01", "2025-05-01", "2025-06-01")),
#'   value = c(10, 12, 4)
#' )
#' ggplot(df, aes(month, value,
#'   alpha = period_is_complete(month, as_of = as.Date("2025-06-15"))
#' )) +
#'   geom_col() +
#'   scale_alpha_logical()
scale_alpha_logical <- function(false_alpha = 0.5, true_alpha = 1) {
  ggplot2::scale_alpha_manual(
    values = c("FALSE" = false_alpha, "TRUE" = true_alpha),
    guide = "none"
  )
}
