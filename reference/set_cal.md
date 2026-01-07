# Set the QuantLib Calendar

These functions wrap
[`qlcal::setCalendar()`](https://rdrr.io/pkg/qlcal/man/setCalendar.html).
They validate that the provided calendar is a valid QuantLib calendar,
and only change the calendar in the case that the validated id is
different from the current calendar.

`set_calendar()` changes the global calendar for the R session. It
invisibly returns the ID of the previously active calendar.

`with_calendar()` and `local_calendar()` allow you to temporarily set a
QuantLib calendar for the duration of an expression or evaluation
context. They behave like other `with_*()` and `local_*()` functions
from
[withr](https://withr.r-lib.org/articles/withr.html#local-functions-and-with-functions)

## Usage

``` r
set_calendar(calendar)

with_calendar(new, code)

local_calendar(new = list(), .local_envir = parent.frame())
```

## Arguments

- calendar, new:

  (character) A single QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

- code:

  Code to execute in the temporary environment

- .local_envir:

  (environment) The environment to use for scoping

## Value

`set_calendar()` returns invisibly the ID of the previously active
calendar.

All functions will error if an invalid calendar id is provided.

## See also

[`qlcal::setCalendar()`](https://rdrr.io/pkg/qlcal/man/setCalendar.html),
[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html)

Note that many functions in `mcrutils` that deal with business days
(e.g.
[`is_bizday()`](https://mcaselli.github.io/mcrutils/reference/is_bizday.md),
[`bizday_of_period()`](https://mcaselli.github.io/mcrutils/reference/bizday_of_period.md),
[`bizdays_between()`](https://mcaselli.github.io/mcrutils/reference/bizdays_between.md)
etc.) accept a `calendar` argument and make internal use of
`local_calendar()`, so you may not need to use these calendar setting
functions directly.

## Examples

``` r
library(qlcal)
isBusinessDay(as.Date("2024-07-04")) # Default calendar
#> [1] TRUE
with_calendar("UnitedStates", {
  # Code here will use the "UnitedStates" calendar
  isBusinessDay(as.Date("2024-07-04"))
})
#> [1] FALSE
isBusinessDay(as.Date("2024-07-04")) # Back to default calendar
#> [1] TRUE
```
