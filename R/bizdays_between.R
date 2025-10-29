#' Calculate Business Days Between Two Dates in a Given QuantLib Calendar
#'
#' Wrapper around [qlcal::businessDaysBetween()] that allows the use of a
#' specified calendar without making persistent changes to which calendar is in
#' use globally.
#'
#' @param from,to start and end dates. Date object or something coercible
#' with [as.Date()].
#' @param calendar (character) A QuantLib calendar id (the vector [qlcal::calendars] lists all valid options).
#' @param include_first,include_last (logical) Whether to include the first and last dates in the count. Defaults to `TRUE`.
#' @return An integer representing the number of business days between the two dates, according to the specified calendar.
#' @seealso [qlcal::calendars()], [qlcal::businessDaysBetween()]
#' @examples
#' bizdays_between("2025-07-01", "2025-07-15", "UnitedStates")
#' bizdays_between("2025-07-01", "2025-07-15", "UnitedKingdom")
#' @export
bizdays_between <- function(from, to, calendar,
                            include_first = TRUE,
                            include_last = TRUE) {
  from <- as.Date(from)
  to <- as.Date(to)
  local_calendar(calendar)

  qlcal::businessDaysBetween(from, to,
    includeFirst = TRUE,
    includeLast = TRUE
  )
}
