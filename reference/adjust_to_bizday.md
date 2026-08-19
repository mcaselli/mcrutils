# Adjust any non-working days to a nearby business day in a given calendar

Adjust any non-working days to a nearby business day in a given calendar

## Usage

``` r
adjust_to_bizday(
  date,
  calendar,
  bdc = c("ModifiedPreceding", "ModifiedFollowing", "Preceding", "Following",
    "Unadjusted", "HalfMonthModifiedFollowing", "Nearest")
)
```

## Arguments

- date:

  A vector of dates (Date object or coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- calendar:

  (character) A QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

- bdc:

  (character) A QuantLib business-day convention. Defaults to
  `"ModifiedPreceding"`: the previous business day, unless that falls in
  the prior month, in which case the next business day. See the
  [QuantLib weekday correction
  docs](https://quantlib-python-docs.readthedocs.io/en/latest/dates.html#weekday-correction)
  for the other conventions.

## Value

A vector of Date objects, the same length as `date`, with any
non-working dates adjusted according to `bdc`. Working days are left
unchanged.

## See also

[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html),
[`qlcal::adjust()`](https://rdrr.io/pkg/qlcal/man/adjust.html),
[`bizday_of_period()`](https://mcaselli.github.io/mcrutils/reference/bizday_of_period.md)

## Examples

``` r
# July 4 is a US holiday, but not a UK holiday
adjust_to_bizday(c("2025-07-03", "2025-07-04"), "UnitedStates")
#> [1] "2025-07-03" "2025-07-03"
adjust_to_bizday(c("2025-07-03", "2024-07-04"), "UnitedKingdom")
#> [1] "2025-07-03" "2024-07-04"

# a month-end weekend stays in its own month
adjust_to_bizday("2025-08-30", "UnitedStates")
#> [1] "2025-08-29"
adjust_to_bizday("2025-08-30", "UnitedStates", bdc = "Following")
#> [1] "2025-09-02"
```
