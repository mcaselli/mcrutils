# Compute history of account activity status over time periods

**\[experimental\]**

This function categorizes accounts into different statuses (new,
returning, temporarily lost, regained, terminally lost and cumulative)
based on their order behavior in each time period. This is useful for
understanding customer retention and churn. Counts of accounts in each
status category can be included by setting `with_counts = TRUE`.

## Usage

``` r
accounts_by_status(
  data,
  account_id,
  order_date,
  by = "month",
  with_counts = FALSE
)
```

## Arguments

- data:

  A data frame or tibble of order information containing at least
  account IDs and order dates

- account_id, order_date:

  \<[`data-masked`](https://dplyr.tidyverse.org/reference/dplyr_data_masking.html)\>
  columns in `data` corresponding to an account identifier and order
  dates, erspectively

- by:

  The time period resolution. Defaults to "month", but anything
  supported as a `unit` argument for
  [lubridate::floor_date](https://lubridate.tidyverse.org/reference/round_date.html)
  and `by` for [seq.Date](https://rdrr.io/r/base/seq.Date.html) is an
  option, e.g. "week", "quarter", "2 months" etc.

- with_counts:

  Logical, if TRUE, include counts of accounts in each status category

## Value

A data frame with columns for period start and end dates, lists of
account IDs in each status category, and optionally counts of accounts
in each category

The function returns a data frame with the following columns:

- `period_start` (date): The start date of the period.

- `period_end` (date) : The end date of the period.

- `active` (list of character): Accounts with orders in the current
  period.

- `new` (list of character): Accounts with their first-ever order in the
  current period.

- `returning` (list of character): Accounts with orders in both the
  current and prior periods.

- `temporarily_lost` (list of character): Accounts with orders in the
  prior period but not in the current period, yet have orders in future
  periods.

- `terminally_lost` (list of character): Accounts with orders in the
  prior period but not in the current period, and no orders in future
  periods.

- `regained` (list of character): Accounts with orders in the current
  period, no orders in the prior period, but had orders in earlier
  periods. i.e. an account that comes back after being "temporarily
  lost"

- `cumulative` (list of character): All accounts that have ever had an
  order up to and including the current period.

if `with_counts` is TRUE, additional columns are included:

- `n_active` (int): Count of active accounts in the current period.

- `n_new` (int): Count of new accounts in the current period.

- `n_returning` (int): Count of returning accounts in the current
  period.

- `n_temporarily_lost` (int): Count of temporarily lost accounts in the
  current period.

- `n_terminally_lost` (int): Count of terminally lost accounts in the
  current period.

- `n_regained` (int): Count of regained accounts in the current period.

- `n_cumulative` (int): Count of all accounts that have ever had an
  order up to and including the current period.

## Examples

``` r
set.seed(1234)
n <- 50
dates <- seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "day")
orders <- data.frame(
  account_id = sample(letters[1:10], n, replace = TRUE),
  order_date = sample(dates, n, replace = TRUE)
)

orders |> accounts_by_status(account_id, order_date, with_counts = TRUE)
#>    period_start period_end              active     new returning regained
#> 1    2022-01-01 2022-01-31             e, f, i e, f, i                   
#> 2    2022-02-01 2022-02-28                c, g    c, g                   
#> 3    2022-03-01 2022-03-31 a, c, d, e, f, i, j a, d, j         c  e, f, i
#> 4    2022-04-01 2022-04-30             a, e, f           a, e, f         
#> 5    2022-05-01 2022-05-31          a, d, f, h       h      a, f        d
#> 6    2022-06-01 2022-06-30          a, d, h, j           a, d, h        j
#> 7    2022-07-01 2022-07-31                   f                          f
#> 8    2022-08-01 2022-08-31          d, f, h, j                 f  d, h, j
#> 9    2022-09-01 2022-09-30             d, e, j              d, j        e
#> 10   2022-10-01 2022-10-31          c, e, g, i                 e  c, g, i
#> 11   2022-11-01 2022-11-30             b, c, h       b         c        h
#> 12   2022-12-01 2022-12-31                b, f                 b        f
#>    temporarily_lost terminally_lost                   cumulative n_active n_new
#> 1                                                        e, f, i        3     3
#> 2           e, f, i                                e, f, i, c, g        2     2
#> 3                 g                       e, f, i, c, g, a, d, j        7     3
#> 4        c, d, i, j                       e, f, i, c, g, a, d, j        3     0
#> 5                 e                    e, f, i, c, g, a, d, j, h        4     1
#> 6                 f                    e, f, i, c, g, a, d, j, h        4     0
#> 7           d, h, j               a    e, f, i, c, g, a, d, j, h        1     0
#> 8                                      e, f, i, c, g, a, d, j, h        4     0
#> 9              f, h                    e, f, i, c, g, a, d, j, h        3     0
#> 10                             d, j    e, f, i, c, g, a, d, j, h        4     0
#> 11                          e, g, i e, f, i, c, g, a, d, j, h, b        3     1
#> 12                             c, h e, f, i, c, g, a, d, j, h, b        2     0
#>    n_returning n_regained n_temporarily_lost n_terminally_lost n_cumulative
#> 1            0          0                  0                 0            3
#> 2            0          0                  3                 0            5
#> 3            1          3                  1                 0            8
#> 4            3          0                  4                 0            8
#> 5            2          1                  1                 0            9
#> 6            3          1                  1                 0            9
#> 7            0          1                  3                 1            9
#> 8            1          3                  0                 0            9
#> 9            2          1                  2                 0            9
#> 10           1          3                  0                 2            9
#> 11           1          1                  0                 3           10
#> 12           1          1                  0                 2           10
```
