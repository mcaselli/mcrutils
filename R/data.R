#' Example sales data
#'
#' A dataset containing example sales data over the time period "2022-01-01" to
#' "2024-12-20". This is fictitious data created for demonstration purposes, and
#' it includes several cohorts of customers--some that are persistent, some that
#' join and leave at various times.
#'
#' @format A data frame with 5300 rows and 2 variables:
#' \describe{
#'  \item{account_id}{Character. A unique identifier for the customer that placed the order.}
#'  \item{market}{Character. The market where the order was placed; either "United States" or "Germany"}
#'  \item{order_date}{Date. The date of the order.}
#'  \item{units_ordered}{Integer. The number of units ordered in that order.}
#' }
#' @source Generated using random sampling for demonstration purposes.
"example_sales"
