#' Find the business day of the period for a given date and calendar
#'
#' Convenience wrapper around `bizdays::bizdays()` that calculates the number of
#' business days from the start of the period (month, quarter, or year) to
#' the given date, using a specified QuantLib calendar for holiday definitions.
#'
#' Be sure to load the calendar first with dates spanning the period of interest.
#'
#' @param date A date (Date object or coercible with [as.Date()])
#' @param calendar A RQuantLib calendar name (see
#' [bizdays::load_quantlib_calendars()]). Don't include the "QuantLib/"
#' prefix.
#' @param period The period type: "month", "quarter", or "year"
#' @return An integer representing the business day of the period for the
#' given date and calendar.
#' @seealso [load_calendars()], [bizdays::load_quantlib_calendars()]
#' @examples
#' # Load the calendar first
#' library(bizdays)
#' load_quantlib_calendars("UnitedStates",
#'   from = as.Date("2023-01-01"),
#'   to = as.Date("2023-12-31")
#' )
#' bizday_of_period(as.Date("2023-03-15"), "UnitedStates", period = "month")
#' bizday_of_period(as.Date("2023-03-15"), "UnitedStates", period = "quarter")
#' bizday_of_period(as.Date("2023-03-15"), "UnitedStates", period = "year")
#' @export
bizday_of_period <- function(date, calendar,
                             period = c("month", "quarter", "year")) {
  period <- rlang::arg_match(period)

  date <- as.Date(date)

  period_start <- lubridate::floor_date(date, unit = period)

  bizdays::bizdays(
    from = period_start,
    to = date,
    cal = paste0("QuantLib/", calendar)
  )
}
