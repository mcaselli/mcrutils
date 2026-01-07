# Calculate previous year dates

Calculates the previous year dates by subtracting one year from the
given dates.

## Usage

``` r
py_dates(dates, ...)
```

## Arguments

- dates:

  a date-time object of class POSIXlt, POSIXct or Date.

- ...:

  Arguments passed on to
  [`lubridate::add_with_rollback`](https://lubridate.tidyverse.org/reference/mplus.html)

  `roll_to_first`

  :   rollback to the first day of the month instead of the last day of
      the previous month (passed to
      [`rollback()`](https://lubridate.tidyverse.org/reference/rollbackward.html))

  `preserve_hms`

  :   retains the same hour, minute, and second information? If FALSE,
      the new date will be at 00:00:00 (passed to
      [`rollback()`](https://lubridate.tidyverse.org/reference/rollbackward.html))

## Value

A vector of dates one year prior to the input dates. Any fictitious
resulting dates (e.g. the result of subtracting a year from a leap day)
are rolled back to the prior valid date.
