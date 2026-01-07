# Calculate yearly breaks for dates

This function calculates yearly breaks for a given range of dates.

## Usage

``` r
calc_year_breaks(dates)
```

## Arguments

- dates:

  A vector of dates, or something coercible with
  [base::as.Date](https://rdrr.io/r/base/as.Date.html)

## Value

A vector of dates representing the start of each year within the range
of `dates`.

## Details

These breaks are floor dates for the year, so
`min(dates) >= min(calc_year_breaks(dates))` and
`max(dates) <= max(calc_yearr_breaks(dates))`.
