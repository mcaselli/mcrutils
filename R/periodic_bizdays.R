#' Calculate the number of business days in periodic intervals
#'
#' A Convenience wrapper for [bizdays::bizdays()]. This function calculates the
#' number of business days in periodic intervals (e.g., monthly, quarterly)
#' between two dates, using specified QuantLib calendars for holiday
#' definitions.
#'
#' @param from,to start and end dates. Date object or something coercible
#' with [as.Date()].
#' @param by periodicity, passed to [seq.Date()] (e.g., "month", "quarter",
#'   "year"). See `?seq.Date` for more options.
#' @param quantlib_calendars = a character vector of RQuantLib calendar names
#'   (see [bizdays::load_quantlib_calendars()]). Don't inlcude the "QuantLib/"
#'   prefix.
#' @return a tibble with columns:
#' \describe{
#'  \item{calendar}{the QuantLib calendar used}
#'  \item{start}{the start date of the period}
#'  \item{end}{the end date of the period}
#'  \item{business_days}{the number of business days in the period,
#'    according to the calendar}
#'  }
#' @examples
#' periodic_bizdays(
#'   from = as.Date("2023-01-01"),
#'   to = as.Date("2023-12-31"),
#'   by = "month",
#'   quantlib_calendars = c("UnitedStates", "UnitedKingdom")
#' )
#' @export
periodic_bizdays <- function(from, to, by = "month",
                             quantlib_calendars = "UnitedStates") {
  from <- as.Date(from)
  to <- as.Date(to)

  suppressMessages(
    bizdays::load_quantlib_calendars(quantlib_calendars,
      from = from,
      # the calendar needs to cover the end date
      to = lubridate::ceiling_date(to, unit = by) + 1
    )
  )

  start <- seq(from, to, by = by)
  end <- dplyr::lead(start) - 1
  end[length(end)] <- to

  tidyr::expand_grid(
    calendar = quantlib_calendars,
    data.frame(start = start, end = end)
  ) |>
    mutate(
      business_days = purrr::pmap_int(
        list(.data$start, .data$end, .data$calendar),
        \(start, end, calendar) {
          bizdays::bizdays(
            from = start,
            to = end,
            cal = paste0("QuantLib/", calendar)
          )
        }
      )
    )
}
