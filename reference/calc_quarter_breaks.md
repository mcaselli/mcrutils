# Calculate quarterly breaks for dates

This function calculates quarterly breaks for a given range of dates.

## Usage

``` r
calc_quarter_breaks(dates)
```

## Arguments

- dates:

  A vector of dates, or something coercible with
  [base::as.Date](https://rdrr.io/r/base/as.Date.html)

## Value

A vector of dates representing the start of each quarter within the
range of `dates`.

## Details

These breaks are floor dates for the quarter, so
`min(dates) >= min(calc_quarter_breaks(dates))` and
`max(dates) <= max(calc_quarter_breaks(dates))`.
