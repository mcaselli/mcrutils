#' Calculate the number of business days in periodic intervals
#'
#' This function calculates the number of business days in periodic intervals
#' (e.g., monthly, quarterly) between two dates, using specified QuantLib
#' calendars for holiday definitions. Convenience wrapper for
#' [bizdays::bizdays()].
#'
#' @param from start date (Date)
#' @param to end date (Date)
#' @param by periodicity, passed to [seq.Date()] (e.g., "month", "quarter",
#'   "year"). See `?seq.Date` for more options.
#' @param quantlib_calendars = a character vector of RQuantLib calendar names
#'   (see [bizdays::load_quantlib_calendars()]). Don't inlcude the "QuantLib/"
#'   prefix.
#' @return a tibble with columns:
#' \describe{
#'  \item{calendar}{the QuantLib calendar used}
#'  \item{start}{the start date of the interval}
#'  \item{end}{the end date of the interval}
#'  \item{business_days}{the number of business days in the interval,
#'    according to the calendar}
#'  }
#' @examples
#' periodic_bizdays(
#'   from = as.Date("2023-01-01"),
#'   to = as.Date("2023-12-31"),
#'   by = "month",
#'   quantlib_calendars = c("UnitedStates", "UnitedKingdom")
#' )
#' @export
periodic_bizdays <- function(from, to, by = "month",
                             quantlib_calendars = "UnitedStates") {
  suppressMessages(
    bizdays::load_quantlib_calendars(quantlib_calendars,
      from = from,
      # the calendar needs to cover the end date
      to = lubridate::ceiling_date(to, unit = by) + 1
    )
  )

  tidyr::expand_grid(
    calendar = quantlib_calendars,
    start = seq(from, to, by = by)
  ) |>
    dplyr::rowwise() |>
    mutate(
      end = lubridate::rollback(lubridate::ceiling_date(.data$start, unit = by)),
      business_days = bizdays::bizdays(
        .data$start,
        .data$end,
        paste0("QuantLib/", .data$calendar)
      )
    )
}
