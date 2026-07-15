# Start or end date of the period containing each date

**\[experimental\]**

`period_start_date()` and `period_end_date()` return the first and last
*calendar* day of the period containing each `date`. They are thin,
coercing, vectorized wrappers around
[`lubridate::floor_date()`](https://lubridate.tidyverse.org/reference/round_date.html)
and
[`lubridate::ceiling_date()`](https://lubridate.tidyverse.org/reference/round_date.html)
that always return a lubridate::Date (never a datetime) and validate
`unit`.

The returned dates are always canonical calendar boundaries.
Business-day calendars are used only to *judge completeness* (see
[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md)),
never to compute a boundary date.

## Usage

``` r
period_start_date(
  date,
  unit = "month",
  week_start = getOption("lubridate.week.start", 7)
)

period_end_date(
  date,
  unit = "month",
  week_start = getOption("lubridate.week.start", 7)
)
```

## Arguments

- date:

  A vector of dates (Date or coercible with
  [`lubridate::as_date()`](https://lubridate.tidyverse.org/reference/as_date.html)).

- unit:

  Period size, one of `"week"`, `"month"`, `"quarter"`, or `"year"`.

- week_start:

  Integer 1-7 giving the first day of the week (only used when
  `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`,
  so the package defers to the session's lubridate week convention.

## Value

A lubridate::Date vector the same length as `date`.

## See also

[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md),
[`last_complete_period_end()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md)

## Examples

``` r
period_start_date(as.Date("2025-05-14"), "month") # 2025-05-01
#> [1] "2025-05-01"
period_end_date(as.Date("2025-05-14"), "month") # 2025-05-31
#> [1] "2025-05-31"
period_end_date(as.Date("2025-05-14"), "quarter") # 2025-06-30
#> [1] "2025-06-30"
```
