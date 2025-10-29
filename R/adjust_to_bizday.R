#' Adjust any non-working days to the following business day in a given calendar
#'
#' @param date A vector of dates (Date object or coercible with [as.Date()]).
#' @param calendar (character) A QuantLib calendar id (the vector
#'   [qlcal::calendars] lists all valid options).
#' @return A vector of Date objects, the same length as date, with any
#'   non-working dates adjusted to the following business day in the specified
#'   calendar. Working days are left unchanged.
#' @seealso [qlcal::calendars()], [qlcal::adjust()]
#' @examples
#' # July 4 is a US holiday, but not a UK holiday
#' adjust_to_bizday(c("2025-07-03", "2025-07-04"), "UnitedStates")
#' adjust_to_bizday(c("2025-07-03", "2024-07-04"), "UnitedKingdom")
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
