#' Find the business day of the period for a given date and calendar
#'
#' Convenience wrapper around [qlcal::businessDaysBetween()] that calculates
#' what business day a date is of a month, quarter, or year, with the first
#' business day ofthe period being 1, the second 2, etc.
#' It uses a specified QuantLib calendar for holiday definitions.
#'
#' NOTE: To ensure predictable, intuitive results, input dates should generally
#' be pre-adjusted to business days using a transparent and deterministic method
#' like [adjust_to_bizday()], [qlcal::adjust()] or similar, because adjustment
#' may cause a date to shift from one period to another, e.g. adjustment of a
#' weekend/holiday to the next business day may cause the date to shift to the
#' next month.
#'
#' @param date A vector of dates (Date object or coercible with [as.Date()]).
#' @param calendar (character) A QuantLib calendar id (the vector [qlcal::calendars] lists all valid options).
#' @param period The period type: "month", "quarter", or "year"
#' @return An integer representing the business day of the period for the
#' given date and calendar.
#' @seealso [qlcal::calendars()], [qlcal::businessDaysBetween()] [adjust_to_bizday()]
#' @examples
#' # valid calendars
#' qlcal::calendars
#'
#' # July 4 is a US holiday, but not a UK holiday
#' bizday_of_period("2024-07-05", "UnitedStates", period = "month")
#' bizday_of_period("2024-07-05", "UnitedKingdom", period = "month")
#'
#' library(dplyr)
#'
#' tibble(
#'   date = seq(as.Date("2025-05-29"), as.Date("2025-06-03"), by = "day"),
#' ) |>
#'   mutate(
#'     day_of_week = weekdays(date),
#'     adjusted_date = adjust_to_bizday(date, "UnitedStates"),
#'     bizday_of_month = bizday_of_period(adjusted_date, "UnitedStates", period = "month"),
#'     bizday_of_year = bizday_of_period(adjusted_date, "UnitedStates", period = "year")
#'   )
#' @export
bizday_of_period <- function(date, calendar,
                             period = c("month", "quarter", "year")) {
  period <- rlang::arg_match(period)
  date <- as.Date(date)

  period_start <- lubridate::floor_date(date, unit = period)

  local_calendar(calendar)

  input_holidays <- date[qlcal::isHoliday(date)]

  if (length(input_holidays) > 0) {
    cli::cli_warn(c(
      "!" = "{cli::qty(input_holidays)}Date{?s} {.val {input_holidays}} {?is a/are} non-working day{?s} in the {.val {calendar}} calendar.",
      "i" = "Business day of period can be misleading when run on unadjusted non-working days.",
      "i" = "Consider adjusting the input dates before calculating business day of period. (See {.fn qlcal::adjust} or {.fn bizdays::adjust.date}"
    ))
  }

  qlcal::businessDaysBetween(period_start, date,
    includeFirst = TRUE,
    includeLast = TRUE
  )
}
