#' Set the QuantLib Calendar
#'
#' @description
#' These functions wrap [qlcal::setCalendar()]. They validate that
#' the provided calendar is a valid QuantLib calendar, and only change the
#' calendar in the case that the validated id is different from the current
#' calendar.
#'
#' `set_calendar()` changes the global calendar for the R session.
#' It invisibly returns the ID of the previously active calendar.
#'
#' `with_calendar()` and `local_calendar()` allow you to temporarily set a
#' QuantLib calendar for the duration of an expression or evaluation context.
#' They behave like other `with_*()` and `local_*()` functions from
#' \href{https://withr.r-lib.org/articles/withr.html#local-functions-and-with-functions}{withr}
#'
#' @param calendar,new (character) A single QuantLib calendar id (the vector
#'   [qlcal::calendars] lists all valid options).
#' @returns `set_calendar()` returns invisibly the ID of the previously active
#'   calendar.
#'
#' All functions will error if an invalid calendar id is provided.
#'
#' @seealso [qlcal::setCalendar()], [qlcal::calendars()]
#'
#' Note that many functions in `mcrutils` that deal with business days
#' (e.g. [is_bizday()], [bizday_of_period()], [bizdays_between()] etc.)
#' accept a `calendar` argument and make internal use of `local_calendar()`, so
#' you may not need to use these calendar setting functions directly.
#'
#' @name set_cal

#' @rdname set_cal
#' @export
set_calendar <- function(calendar) {
  check_valid_single_calendar(calendar)
  old_calendar <- get_calendar(NULL)
  if (!old_calendar == calendar) {
    qlcal::setCalendar(calendar)
  }
  return(invisible(old_calendar))
}

# internal, only used by with_ and local_
get_calendar <- function(calendar) {
  qlcal::getId()
}

#' @rdname set_cal
#' @param code Code to execute in the temporary environment
#' @export
#' @examples
#' library(qlcal)
#' isBusinessDay(as.Date("2024-07-04")) # Default calendar
#' with_calendar("UnitedStates", {
#'   # Code here will use the "UnitedStates" calendar
#'   isBusinessDay(as.Date("2024-07-04"))
#' })
#' isBusinessDay(as.Date("2024-07-04")) # Back to default calendar
with_calendar <- withr::with_(
  set = set_calendar,
  get = get_calendar
)


#' @rdname set_cal
#' @param .local_envir (environment) The environment to use for scoping
#' @export
local_calendar <- withr::local_(
  set = set_calendar,
  get = get_calendar
)
