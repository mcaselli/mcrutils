# Find the start and end dates of the year-to-date period

Calculates the start and end dates of the year-to-date period based on
the maximum date in the provided dates. Both partial- and full-month
methods are supported, see `rollback_partial_month`.

## Usage

``` r
ytd_bounds(dates, rollback_partial_month = FALSE)
```

## Arguments

- dates:

  a vector of dates, or something coercible with
  [`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html)

- rollback_partial_month:

  If TRUE, and the maximum date in `dates` is not an end-of-month date,
  the end date will be rolled back to the last day of the previous
  month. If FALSE the end date will be the maximum date in `dates`.

## Value

A vector containing the start and end dates of the year-to-date period.

## Examples

``` r
ytd_bounds(c("2023-02-04", "2024-02-02", "2024-02-14"))
#> [1] "2024-01-01" "2024-02-14"

ytd_bounds(
  c("2023-12-04", "2024-02-14"),
  rollback_partial_month = TRUE
)
#> [1] "2024-01-01" "2024-01-31"
```
