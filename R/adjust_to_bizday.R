#' Adjust any non-working days to a nearby business day in a given calendar
#'
#' @param date A vector of dates (Date object or coercible with [as.Date()]).
#' @param calendar (character) A QuantLib calendar id (the vector
#'   [qlcal::calendars] lists all valid options).
#' @param bdc (character) A QuantLib business-day convention. Defaults to
#'   `"Preceding"`: the previous business day, even if that falls in the prior
#'   month. See the
#'   [QuantLib weekday correction docs](https://quantlib-python-docs.readthedocs.io/en/latest/dates.html#weekday-correction)
#'   for the other conventions.
#' @return A vector of Date objects, the same length as `date`, with any
#'   non-working dates adjusted according to `bdc`. Working days are left
#'   unchanged.
#' @seealso [qlcal::calendars()], [qlcal::adjust()], [bizday_of_period()]
#' @examples
#' # July 4 is a US holiday, but not a UK holiday
#' adjust_to_bizday(c("2025-07-03", "2025-07-04"), "UnitedStates")
#' adjust_to_bizday(c("2025-07-03", "2024-07-04"), "UnitedKingdom")
#'
#' # a month-end weekend stays in its own month
#' adjust_to_bizday("2025-08-30", "UnitedStates")
#' adjust_to_bizday("2025-08-30", "UnitedStates", bdc = "Following")
#' @export
adjust_to_bizday <- function(
  date,
  calendar,
  bdc = c(
    "Preceding",
    "ModifiedPreceding",
    "ModifiedFollowing",
    "Following",
    "Unadjusted",
    "HalfMonthModifiedFollowing",
    "Nearest"
  )
) {
  date <- as.Date(date)
  check_valid_single_calendar(calendar)
  bdc <- rlang::arg_match(bdc)

  start_cal <- qlcal::getId()
  if (!start_cal == calendar) {
    withr::defer(qlcal::setCalendar(start_cal))
    qlcal::setCalendar(calendar)
  }
  result <- qlcal::adjust(date, bdc = bdc)
  return(result)
}
