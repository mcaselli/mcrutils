#' Adjust any non-working days to the following business day in a given calendar
#'
#' @param date A vector of dates (Date object or coercible with [as.Date()]).
#' @param calendar (character) A QuantLib calendar id (the vector [qlcal::calendars] lists all valid options).
#' @return A vector of Date objects adjusted to the following business day in the specified calendar.
#' @seealso [qlcal::calendars()], [qlcal::adjust()]
#' @examples
#' adjust_to_bizday(c("2025-07-04", "2025-05-31"), "UnitedStates")
#' adjust_to_bizday(c("2025-01-15", "2025-01-16"), "UnitedStates")
#' @export
adjust_to_bizday <- function(date, calendar) {
  date <- as.Date(date)
  check_valid_single_calendar(calendar)

  start_cal <- qlcal::getId()
  if (!start_cal == calendar) {
    withr::defer(qlcal::setCalendar(start_cal))
    qlcal::setCalendar(calendar)
  }
  result <- qlcal::adjust(date, bdc = "Following")
  return(result)
}
