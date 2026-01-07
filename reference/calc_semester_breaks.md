# Calculate semester breaks for dates

This function calculates semester breaks for a given range of dates.

## Usage

``` r
calc_semester_breaks(dates)
```

## Arguments

- dates:

  A vector of dates, or something coercible with
  [base::as.Date](https://rdrr.io/r/base/as.Date.html)

## Value

A vector of dates representing the start of each semester within the
range of `dates`.

## Details

These breaks are floor dates for the semester, so
`min(dates) >= min(calc_semester_breaks(dates))` and
`max(dates) <= max(calc_quarter_breaks(dates))`.
