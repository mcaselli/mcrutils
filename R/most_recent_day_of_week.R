#' Get the date of the prior Sunday or Monday
#'
#' This function returns the date of the most recent Sunday or Monday that
#' is on or before the current date or a specified reference date.
#'
#' @param ref_date A date object or a string representing a date.
#' Defaults to NULL, which uses the current date.
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
most_recent_monday <- function(ref_date = NULL) {
  if (!is.null(ref_date)) {
    ref_date <- as.Date(ref_date)
  } else {
    ref_date <- Sys.Date()
  }
  weekday <- as.integer(format(ref_date, "%u")) # 1 = Monday, 7 = Sunday
  days_to_subtract <- ifelse(weekday == 1, 0, weekday - 1)
  ref_date - days_to_subtract
}

#' @rdname most_recent_x_day
#' @export
most_recent_sunday <- function(ref_date = NULL) {
  if (!is.null(ref_date)) {
    ref_date <- as.Date(ref_date)
  } else {
    ref_date <- Sys.Date()
  }
  weekday <- as.integer(format(ref_date, "%u")) # 1 = Monday, 7 = Sunday
  days_to_subtract <- ifelse(weekday == 7, 0, weekday)
  ref_date - days_to_subtract
}
