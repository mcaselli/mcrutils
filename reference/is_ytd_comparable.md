# Is a date comparable for year-to-date (YTD) calculations?

Is the month and day of date on or before that of end_date? Useful for
creating YTD comparisons using historical data.

## Usage

``` r
is_ytd_comparable(date, end_date)
```

## Arguments

- date:

  A date object. (coercible using
  [`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html))

- end_date:

  A reference end-date to compare against. (i.e. the YTD end date)
  (coercible using
  [`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html))

## Value

`TRUE` if the month and day of date is on or before that of end_date,
`FALSE` otherwise.

## Note

`datetimes` are coerced to `dates`, so the time component is ignored.

## Examples

``` r
is_ytd_comparable("2023-05-04", "2024-05-31")
#> [1] TRUE
```
