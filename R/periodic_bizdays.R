#' Calculate the Number of Business Days in Months, Quarters, etc
#'
#' This function calculates the number of business days in each periodic
#' interval (e.g., month, quarter) between two dates, using specified QuantLib
#' calendars for holiday definitions.
#'
#' @param from,to start and end dates. Date object or something coercible
#' with [as.Date()].
#' @param by periodicity, passed to [seq.Date()] (e.g., "month", "quarter",
#'   "year"). See [seq.Date()] for more options.
#' @param quantlib_calendars (character) A vector of QuantLib calendar ids (the
#'   vector [qlcal::calendars] lists all valid options).
#' @return a tibble with columns:
#' \describe{
#'  \item{calendar}{the QuantLib calendar used}
#'  \item{start}{the start date of the period}
#'  \item{end}{the end date of the period}
#'  \item{business_days}{the number of business days in the period,
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
  from <- as.Date(from)
  to <- as.Date(to)

  start <- seq(from, to, by = by)
  end <- dplyr::lead(start) - 1
  end[length(end)] <- to

  tidyr::expand_grid(
    calendar = quantlib_calendars,
    data.frame(start = start, end = end)
  ) |>
    mutate(
      business_days = purrr::pmap_int(
        list(.data$start, .data$end, .data$calendar),
        \(start, end, calendar) {
          bizdays_between(
            from = start,
            to = end,
            calendar = calendar
          )
        }
      )
    )
}
