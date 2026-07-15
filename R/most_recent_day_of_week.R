#' Get the date of the prior Sunday or Monday
#'
#' This function returns the date of the most recent Sunday or Monday that
#' is on or before the current date or a specified reference date.
#'
#' @param as_of A date object or a string representing the date to evaluate
#' relative to. Defaults to NULL, which uses the current date.
#'
#' @return A Date object representing the most recent Sunday or Monday
#' @examples
#' most_recent_monday() # Returns the most recent Monday from today
#' # Returns c("2025-12-29", "2026-01-05")
#' most_recent_monday(c("2026-01-04", "2026-01-05"))
#' most_recent_sunday("2024-06-15") # Returns "2024-06-09"
#' @name most_recent_x_day
NULL

#' @rdname most_recent_x_day
#' @export
most_recent_monday <- function(as_of = NULL) {
  if (!is.null(as_of)) {
    as_of <- as.Date(as_of)
  } else {
    as_of <- Sys.Date()
  }
  weekday <- as.integer(format(as_of, "%u")) # 1 = Monday, 7 = Sunday
  days_to_subtract <- ifelse(weekday == 1, 0, weekday - 1)
  as_of - days_to_subtract
}

#' @rdname most_recent_x_day
#' @export
most_recent_sunday <- function(as_of = NULL) {
  if (!is.null(as_of)) {
    as_of <- as.Date(as_of)
  } else {
    as_of <- Sys.Date()
  }
  weekday <- as.integer(format(as_of, "%u")) # 1 = Monday, 7 = Sunday
  days_to_subtract <- ifelse(weekday == 7, 0, weekday)
  as_of - days_to_subtract
}
