# Calculate Business Days Between Two Dates in a Given QuantLib Calendar

Wrapper around
[`qlcal::businessDaysBetween()`](https://rdrr.io/pkg/qlcal/man/businessDaysBetween.html)
that allows the use of a specified calendar without making persistent
changes to which calendar is in use globally.

## Usage

``` r
bizdays_between(from, to, calendar, include_first = TRUE, include_last = TRUE)
```

## Arguments

- from, to:

  start and end dates. Date object or something coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- calendar:

  (character) A QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

- include_first, include_last:

  (logical) Whether to include the first and last dates in the count.
  Defaults to `TRUE`.

## Value

An integer representing the number of business days between the two
dates, according to the specified calendar.

## See also

[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html),
[`qlcal::businessDaysBetween()`](https://rdrr.io/pkg/qlcal/man/businessDaysBetween.html)

## Examples

``` r
bizdays_between("2025-07-01", "2025-07-15", "UnitedStates")
#> [1] 10
bizdays_between("2025-07-01", "2025-07-15", "UnitedKingdom")
#> [1] 11
```
