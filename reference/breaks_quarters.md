# Generate quarterly, semester, or year breaks for dates

This function generates breaks for quarterly, semester, or yearly
intervals, either in fixed-width mode or automatic mode.

## Usage

``` r
breaks_quarters(n = 9, width = NULL)
```

## Arguments

- n:

  The number of breaks to generate in automatic mode.

- width:

  The fixed width of breaks in fixed-width mode. Should be a
  specification of the form `"n unit"`, where `n` is a number and `unit`
  is one of "month", "quarter", or "year" (optionally plural). For
  example, "3 months", "1 quarter", or "2 years". If unit is months,
  value must be 3, 6 or 12 (so you get quarters). If unit is quarters,
  value must be 1, 2, or 4 (so you get quarters, semesters, or years).
  If unit is years, value must be 1.

  @note This function will never create breaks longer than one year. If
  that's desired, you're probably better off sticking with the standard
  ggplot approach
  `scale_x_date(date_breaks = "5 years", date_labels = "%y")`.

## Value

A function that takes a vector of dates and returns a vector of dates
for use as breaks
