#' Load QuantLib Calendars to cover the years spanning given dates
#'
#' Convenience wrapper around [bizdays::load_quantlib_calendars()] that
#' calculates the appropriate `from` and `to` arguments to cover the entire
#' years spanned by a vector of dates.
#'
#' @param dates A vector of dates (Date objects or coercible with [as.Date()])
#' @param calendars A character vector of RQuantLib calendar names
#'   (see [bizdays::load_quantlib_calendars()]). Don't include the "QuantLib/"
#'   prefix.
#' @param financial see [bizdays::load_quantlib_calendars()]. Defaults to
#'   `FALSE`, which has the result that the ending business day is considered
#'   when counting elapsed bizdays between two dates, which yields the results
#'   we're looking for here (i.e. inclusive counting). Note this is the opposite
#'   of the default behavior of [bizdays::load_quantlib_calendars()].
#' @param quiet Logical indicating whether to suppress messages during loading
#'   (default: TRUE)
#' @return Invisibly returns NULL. Calendars are loaded.
#' @export
load_calendars <- function(dates, calendars, financial = FALSE, quiet = TRUE) {
  dates <- as.Date(dates)

  expr <- rlang::expr(
    bizdays::load_quantlib_calendars(calendars,
      from = lubridate::floor_date(min(dates), unit = "year"),
      to = lubridate::ceiling_date(max(dates), unit = "year"),
      financial = financial
    )
  )

  if (quiet) suppressMessages(eval(expr)) else eval(expr)
}
