#' Find the start and end dates of the year-to-date period
#'
#' Calculates the start and end dates of the year-to-date period
#' based on the maximum date in the provided dates. Both partial-
#' and full-month methods are supported, see `rollback_partial_month`.
#'
#' @param dates a vector of dates, or something coercible with
#'   [lubridate::as_date()]
#' @param rollback_partial_month If TRUE, and the maximum date in `dates`
#'   is not an end-of-month date, the end date will be rolled back to the
#'   last day of the previous month. If FALSE the end date will be the maximum
#'   date in `dates`.
#'
#' @return A vector containing the start and end dates of the year-to-date period.
#' @export
#'
#' @examples
#' ytd_bounds(c("2023-02-04", "2024-02-02", "2024-02-14"))
#'
#' ytd_bounds(
#'   c("2023-12-04", "2024-02-14"),
#'   rollback_partial_month = TRUE
#' )
ytd_bounds <- function(dates, rollback_partial_month = FALSE) {
  max_date <- dates |>
    max(na.rm = TRUE) |>
    lubridate::as_date()

  year_start <- lubridate::floor_date(max_date, unit = "year")

  eom <- lubridate::ceiling_date(max_date, unit = "month") - lubridate::days(1)

  # if max_date is the last day of the month, treat it as a full month, so don't roll back max_date
  if (rollback_partial_month && max_date < eom) {
    max_date <- lubridate::rollback(max_date)
  }
  c(year_start, max_date)
}


#' Calculate previous year dates
#'
#' Calculates the previous year dates
#' by subtracting one year from the given dates.
#'
#' @param dates a date-time object of class POSIXlt, POSIXct or Date.
#' @inheritDotParams lubridate::add_with_rollback -e1 -e2
#'
#' @return A vector of dates one year prior to the input dates.
#' Any fictitious resulting dates (e.g. the result of subtracting a year
#' from a leap day) are rolled back to the prior valid date.
#' @export
py_dates <- function(dates, ...) {
  lubridate::add_with_rollback(dates, lubridate::years(-1), ...)
}


#' Is a date comparable for year-to-date (YTD) calculations?
#'
#' Is the month and day of date  on or before that of end_date?
#' Useful for creating YTD comparisons using historical data.
#'
#' @param date A date object. (coercible using [lubridate::as_date()])
#' @param end_date A reference end-date to compare against. (i.e. the YTD end date)
#' (coercible using [lubridate::as_date()])
#'
#' @return `TRUE` if the month and day of date is on or before that of end_date,
#' `FALSE` otherwise.
#' @note `datetimes` are coerced to `dates`, so the time component is ignored.
#'
#' @importFrom stats update
#' @export
#' @examples
#' is_ytd_comparable("2023-05-04", "2024-05-31")
is_ytd_comparable <- function(date, end_date) {
  stopifnot(length(end_date) == 1 || length(end_date) == length(date))
  # find the comparable end date in the year of date
  comp_date <- update(
    lubridate::as_date(end_date),
    year = lubridate::year(lubridate::as_date(date))
  )
  return(date <= comp_date)
}
