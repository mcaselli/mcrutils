# Adjust any non-working days to the following business day in a given calendar

Adjust any non-working days to the following business day in a given
calendar

## Usage

``` r
adjust_to_bizday(date, calendar)
```

## Arguments

- date:

  A vector of dates (Date object or coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- calendar:

  (character) A QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

## Value

A vector of Date objects, the same length as date, with any non-working
dates adjusted to the following business day in the specified calendar.
Working days are left unchanged.

## See also

[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html),
[`qlcal::adjust()`](https://rdrr.io/pkg/qlcal/man/adjust.html)

## Examples

``` r
# July 4 is a US holiday, but not a UK holiday
adjust_to_bizday(c("2025-07-03", "2025-07-04"), "UnitedStates")
#> [1] "2025-07-03" "2025-07-07"
adjust_to_bizday(c("2025-07-03", "2024-07-04"), "UnitedKingdom")
#> [1] "2025-07-03" "2024-07-04"
```
