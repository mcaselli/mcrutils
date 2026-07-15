# Boundary of the most recent complete period as of a cutoff

**\[experimental\]**

`last_complete_period_end()` returns the (canonical calendar) end date
of the most recent period that is complete as of `as_of`;
`last_complete_period_start()` returns that period's start date.
Completeness is judged with
[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md),
so `calendar` selects the policy exactly as it does there.

## Usage

``` r
last_complete_period_end(
  as_of,
  unit = "month",
  calendar = "WeekendsOnly",
  week_start = getOption("lubridate.week.start", 7)
)

last_complete_period_start(
  as_of,
  unit = "month",
  calendar = "WeekendsOnly",
  week_start = getOption("lubridate.week.start", 7)
)
```

## Arguments

- as_of:

  Reference cutoff date(s) (Date or coercible). Required—there is no
  default. Use the latest date in your data for completeness relative to
  how current the data is, or
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html) for the current
  date.

- unit:

  Period size, one of `"week"`, `"month"`, `"quarter"`, or `"year"`.

- calendar:

  (character) A QuantLib calendar id (see
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html)).
  Defaults to `"WeekendsOnly"`.

- week_start:

  Integer 1-7 giving the first day of the week (only used when
  `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.

## Value

A lubridate::Date vector the same length as `as_of`.

## See also

[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md),
[`period_end_date()`](https://mcaselli.github.io/mcrutils/reference/period_bounds.md)

## Examples

``` r
# 2025-05-30 falls in Q2 2025, which is still in progress, so the most recent
# complete quarter ends 2025-03-31.
last_complete_period_end(as.Date("2025-05-30"), unit = "quarter")
#> [1] "2025-03-31"
last_complete_period_start(as.Date("2025-05-30"), unit = "quarter")
#> [1] "2025-01-01"
```
