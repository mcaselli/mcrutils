
#' List active accounts in a date range
#'
#' @param account_id A vector of account IDs
#' @param order_date A vector of order dates corresponding to the account IDs
#' @param start_date The start date of the range (inclusive)
#' @param end_date The end date of the range (inclusive)
#' @return A vector of unique account IDs that were active in the specified date range
active_accounts_in_range <- function(account_id, order_date, start_date, end_date) {
  df <- data.frame(account_id = account_id, order_date = as.Date(order_date))
  active_accounts <- df |>
    # both date bounds are inclusive--does that make using this function
    # more difficult than e.g. having the upper bound be exclusive?
    dplyr::filter(order_date >= start_date & order_date <= end_date) |>
    dplyr::distinct(account_id) |>
    dplyr::arrange(account_id) |>
    dplyr::pull(account_id)
  return(active_accounts)
}

#' Analyze account activity status over time periods
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' This function categorizes accounts into various statuses (new, returning,
#' temporarily lost, terminally lost, and regained) over specified time periods
#' (monthly or quarterly). This is useful for understanding customer retention
#' and churn.
#'
#'
#' @param account_id A vector of account IDs
#' @param order_date A vector of order dates corresponding to the account IDs
#' @param by The time period to group by, either "month" or "quarter"
#' @param with_counts Logical, if TRUE, include counts of accounts in each
#'   status category
#' @return A data frame with columns for period start and end dates, lists of
#'   account IDs in each status category, and optionally counts of accounts in
#'   each category
#'
#' The function returns a data frame with the following columns:
#' - `period_start` (date): The start date of the period.
#' - `period_end` (date) : The end date of the period.
#' - `active_accounts` (list of character): Accounts with orders in the current
#' period.
#' - `new_accounts` (list of character): Accounts with their first-ever order in
#' the current period.
#' - `returning_accounts` (list of character): Accounts with orders in both the
#' current and prior periods.
#' - `temporarily_lost_accounts` (list of character): Accounts with orders in
#' the prior period but not in the current period, yet have orders in future
#' periods.
#' - `terminally_lost_accounts` (list of character): Accounts with orders in the
#' prior period but not in the current period, and no orders in future periods.
#' - `regained_accounts` (list of character): Accounts with orders in the current period, no orders in
#' the prior period, but had orders in earlier periods. i.e. an account that
#' comes back after being "temporarily lost"
#'
#' if `with_counts` is TRUE, additional columns are included:
#' - `n_active_accounts` (int): Count of active accounts in the current period.
#' - `n_new_accounts` (int): Count of new accounts in the current period.
#' - `n_returning_accounts` (int): Count of returning accounts in the current period.
#' - `n_temporarily_lost_accounts` (int): Count of temporarily lost accounts in the
#' current period.
#' - `n_terminally_lost_accounts` (int): Count of terminally lost accounts in the
#' current period.
#' - `n_regained_accounts` (int): Count of regained accounts in the current period.
#' @export
#'
#' @examples
#' set.seed(1234)
#' n <- 50
#' dates <- seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "day")
#' orders <- data.frame(
#'  account_id = sample(letters[1:10], n, replace = TRUE),
#'  order_date = sample(dates, n, replace = TRUE)
#' )
#'
#' accounts_by_status(orders$account_id, orders$order_date, with_counts = TRUE)
accounts_by_status <- function(account_id, order_date, by = c("month", "quarter"),
                               with_counts = FALSE) {
  by <- rlang::arg_match(by)
  df <- data.frame(account_id = account_id, order_date = as.Date(order_date))

  date_range <- range(df$order_date)

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
      active_accounts = purrr::map2(
        period_start, period_end,
        ~ active_accounts_in_range(
          account_id = df$account_id,
          order_date = df$order_date,
          start_date = .x,
          end_date = .y
        )
      )
    )

  for (i in 1:nrow(result)) {
    cumulative_prior_accounts <- if (i > 1) {
      unique(unlist(result$active_accounts[1:i - 1]))
    } else {
      character(0)
    }
    prior_period_active_accounts <- if (i > 1) {
      unlist(result$active_accounts[[i - 1]])
    } else {
      character(0)
    }
    cumulative_future_active_accounts <- if (i < nrow(result)) {
      unique(unlist(result$active_accounts[(i + 1):nrow(result)]))
      # } else character(0) # assume no returning customers after the final period
    } else {
      # assume all customers ordering in the final period eventually come back
      result$active_accounts[[nrow(result)]]
    }

    # result$cumulative_prior_accounts[[i]] <- list(cumulative_prior_accounts)
    new_accounts <- setdiff(result$active_accounts[[i]], cumulative_prior_accounts)
    result$new_accounts[[i]] <- list(new_accounts)

    returning_accounts <- intersect(result$active_accounts[[i]], prior_period_active_accounts)
    result$returning_accounts[[i]] <- list(returning_accounts)

    terminally_lost_accounts <- setdiff(
      setdiff(prior_period_active_accounts, result$active_accounts[[i]]),
      cumulative_future_active_accounts
    )
    result$terminally_lost_accounts[[i]] <- list(terminally_lost_accounts)

    temporarily_lost_accounts <- intersect(
      setdiff(prior_period_active_accounts, result$active_accounts[[i]]),
      cumulative_future_active_accounts
    )
    result$temporarily_lost_accounts[[i]] <- list(temporarily_lost_accounts)

    regained_accounts <- setdiff(setdiff(result$active_accounts[[i]], prior_period_active_accounts), new_accounts)
    result$regained_accounts[[i]] <- list(regained_accounts)
  }

  result <- result |>
    dplyr::relocate(regained_accounts, temporarily_lost_accounts, terminally_lost_accounts, .after = returning_accounts)

  if (with_counts){
    result <- result |>
      dplyr::rowwise() |>
      dplyr::mutate(
        across(
          .cols = dplyr::ends_with("_accounts"),
          .fns = ~ length(unlist(.x)),
          .names = "n_{.col}"
        )
      ) |>
      data.frame()
  }

  return(result)
}


