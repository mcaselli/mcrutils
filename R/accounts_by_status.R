#' List active accounts in a date range
#'
#' @param data A data frame or tibble of order information containing at least
#'   account IDs and order dates
#' @param account_id,order_date <[`data-masked`][dplyr::dplyr_data_masking]>
#'   columns in `data` corresponding to an account identifier and order dates,
#'   erspectively
#' @param start_date,end_date The start date and end_date of the range (inclusive)
#' @return A vector of unique account IDs that were active in the specified date range
active_accounts_in_range <- function(data, account_id, order_date, start_date, end_date) {
  active_accounts <- data |>
    mutate({{ order_date }} := as.Date({{ order_date }})) |>
    # both date bounds are inclusive--does that make using this function
    # more difficult than e.g. having the upper bound be exclusive?
    dplyr::filter({{ order_date }} >= start_date & {{ order_date }} <= end_date) |>
    dplyr::distinct({{ account_id }}) |>
    dplyr::arrange({{ account_id }}) |>
    dplyr::pull({{ account_id }})
  return(active_accounts)
}

#' Compute history of account activity status over time periods
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' This function categorizes accounts into different statuses (new, returning,
#' temporarily lost, regained, terminally lost and cumulative) based on their
#' order behavior in each time period. This is useful for
#' understanding customer retention and churn. Counts of accounts in each status
#' category can be included by setting `with_counts = TRUE`.
#'
#'
#' @inheritParams active_accounts_in_range
#' @param by The time period resolution. Defaults to "month", but anything
#'   supported as a `unit` argument for [lubridate::floor_date] and `by` for
#'   [seq.Date] is an option, e.g. "week", "quarter", "2 months" etc.
#' @param with_counts Logical, if TRUE, include counts of accounts in each
#'   status category
#' @return A data frame with columns for period start and end dates, lists of
#'   account IDs in each status category, and optionally counts of accounts in
#'   each category
#'
#' The function returns a data frame with the following columns:
#' - `period_start` (date): The start date of the period.
#' - `period_end` (date) : The end date of the period.
#' - `active` (list of character): Accounts with orders in the current
#' period.
#' - `new` (list of character): Accounts with their first-ever order in
#' the current period.
#' - `returning` (list of character): Accounts with orders in both the
#' current and prior periods.
#' - `temporarily_lost` (list of character): Accounts with orders in
#' the prior period but not in the current period, yet have orders in future
#' periods.
#' - `terminally_lost` (list of character): Accounts with orders in the
#' prior period but not in the current period, and no orders in future periods.
#' - `regained` (list of character): Accounts with orders in the current period, no orders in
#' the prior period, but had orders in earlier periods. i.e. an account that
#' comes back after being "temporarily lost"
#' - `cumulative` (list of character): All accounts that have ever had an order
#' up to and including the current period.
#'
#' if `with_counts` is TRUE, additional columns are included:
#' - `n_active` (int): Count of active accounts in the current period.
#' - `n_new` (int): Count of new accounts in the current period.
#' - `n_returning` (int): Count of returning accounts in the current period.
#' - `n_temporarily_lost` (int): Count of temporarily lost accounts in the
#' current period.
#' - `n_terminally_lost` (int): Count of terminally lost accounts in the
#' current period.
#' - `n_regained` (int): Count of regained accounts in the current period.
#' - `n_cumulative` (int): Count of all accounts that have ever had an order
#' up to and including the current period.
#' @export
#'
#' @examples
#' set.seed(1234)
#' n <- 50
#' dates <- seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "day")
#' orders <- data.frame(
#'   account_id = sample(letters[1:10], n, replace = TRUE),
#'   order_date = sample(dates, n, replace = TRUE)
#' )
#'
#' orders |> accounts_by_status(account_id, order_date, with_counts = TRUE)
accounts_by_status <- function(data, account_id, order_date, by = "month",
                               with_counts = FALSE) {
  data <- data |>
    dplyr::mutate({{ order_date }} := as.Date({{ order_date }}))

  date_range <- data |>
    dplyr::pull({{ order_date }}) |>
    range(na.rm = TRUE)

  period_start <- seq(
    from = lubridate::floor_date(date_range[1], unit = by),
    to = lubridate::floor_date(date_range[2], unit = by),
    by = by
  )
  period_end <- lubridate::ceiling_date(period_start, unit = by) - 1

  result <- data.frame(
    period_start = period_start,
    period_end = period_end
  ) |>
    mutate(
      active = purrr::map2(
        period_start, period_end,
        ~ active_accounts_in_range(
          data = data,
          account_id = {{ account_id }},
          order_date = {{ order_date }},
          start_date = .x,
          end_date = .y
        )
      )
    )

  for (i in 1:nrow(result)) {
    cumulative_prior <- if (i > 1) {
      unique(unlist(result$active[1:i - 1]))
    } else {
      character(0)
    }
    prior_period_active <- if (i > 1) {
      unlist(result$active[[i - 1]])
    } else {
      character(0)
    }
    cumulative_future_active <- if (i < nrow(result)) {
      unique(unlist(result$active[(i + 1):nrow(result)]))
      # } else character(0) # assume no returning customers after the final period
    } else {
      # assume all customers ordering in the final period eventually come back
      result$active[[nrow(result)]]
    }

    # result$cumulative_prior[[i]] <- list(cumulative_prior)
    new <- setdiff(result$active[[i]], cumulative_prior)
    result$new[[i]] <- new

    returning <- intersect(result$active[[i]], prior_period_active)
    result$returning[[i]] <- returning

    terminally_lost <- setdiff(
      setdiff(prior_period_active, result$active[[i]]),
      cumulative_future_active
    )
    result$terminally_lost[[i]] <- terminally_lost

    temporarily_lost <- intersect(
      setdiff(prior_period_active, result$active[[i]]),
      cumulative_future_active
    )
    result$temporarily_lost[[i]] <- temporarily_lost

    regained <- setdiff(setdiff(result$active[[i]], prior_period_active), new)
    result$regained[[i]] <- regained

    cumulative <- union(cumulative_prior, result$active[[i]])
    result$cumulative[[i]] <- cumulative
  }

  result <- result |>
    dplyr::relocate(regained, temporarily_lost, terminally_lost, .after = returning)

  if (with_counts) {
    result <- result |>
      dplyr::rowwise() |>
      dplyr::mutate(
        across(
          .cols = -c(period_start, period_end),
          .fns = ~ length(unlist(.x)),
          .names = "n_{.col}"
        )
      ) |>
      data.frame()
  }

  return(result)
}
