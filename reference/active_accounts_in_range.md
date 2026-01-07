# List active accounts in a date range

List active accounts in a date range

## Usage

``` r
active_accounts_in_range(data, account_id, order_date, start_date, end_date)
```

## Arguments

- data:

  A data frame or tibble of order information containing at least
  account IDs and order dates

- account_id, order_date:

  \<[`data-masked`](https://dplyr.tidyverse.org/reference/dplyr_data_masking.html)\>
  columns in `data` corresponding to an account identifier and order
  dates, erspectively

- start_date, end_date:

  The start date and end_date of the range (inclusive)

## Value

A vector of unique account IDs that were active in the specified date
range
