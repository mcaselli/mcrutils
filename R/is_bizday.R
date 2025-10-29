#' Check if Date is a Business Day in a Given Calendar
#'
#' This function checks if the provided date(s) are business days according to the specified QuantLib calendar.
#'
#' @param date A vector of dates (Date object or coercible with [as.Date()]).
#' @param calendar (character) A QuantLib calendar id (the vector [qlcal::calendars] lists all valid options).
#' @return A logical vector indicating whether each date is a business day in the specified calendar.
#' @seealso [qlcal::calendars()], [qlcal::isBusinessDay()]
#' @export
#' @examples
#' # valid calendars
#' qlcal::calendars
#' # July 4, 2024 is a US holiday, but not a UK holiday
#' is_bizday(c("2024-07-04", "2024-07-05"), "UnitedStates")
#' is_bizday(c("2024-07-04", "2024-07-05"), "UnitedKingdom")
is_bizday <- function(date, calendar) {
  check_valid_single_calendar(calendar)
  date <- as.Date(date)

  start_cal <- qlcal::getId()
  if (!start_cal == calendar) {
    withr::defer(qlcal::setCalendar(start_cal))
    qlcal::setCalendar(calendar)
  }
  qlcal::isBusinessDay(date)
}
