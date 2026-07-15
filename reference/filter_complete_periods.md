# Keep only rows whose period is complete as of a cutoff

**\[experimental\]**

Filters `data` to the rows whose period (per
[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md))
is complete as of `as_of`. Useful for dropping the in-progress trailing
period from a summary or year-over-year comparison.

## Usage

``` r
filter_complete_periods(
  data,
  date_col,
  unit = "month",
  as_of = NULL,
  calendar = "WeekendsOnly",
  week_start = getOption("lubridate.week.start", 7)
)
```

## Arguments

- data:

  A data frame.

- date_col:

  \<[`data-masked`](https://dplyr.tidyverse.org/reference/dplyr_data_masking.html)\>
  The date column whose period completeness is tested.

- unit:

  Period size, one of `"week"`, `"month"`, `"quarter"`, or `"year"`.

- as_of:

  Reference cutoff date, a single Date (or coercible). Defaults to
  `NULL`, in which case it is set to the maximum of `date_col` so
  completeness is judged against how current the data actually is. An
  explicit `as_of` *earlier* than the maximum of `date_col` is an error,
  because it would drop periods the data demonstrably completes; use
  [`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md)
  directly for point-in-time completeness.

- calendar:

  (character) A QuantLib calendar id (see
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html)).
  Defaults to `"WeekendsOnly"`.

- week_start:

  Integer 1-7 giving the first day of the week (only used when
  `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.

## Value

`data` filtered to rows in complete periods.

## See also

[`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md)

## Examples

``` r
df <- data.frame(day = seq(as.Date("2025-04-01"), as.Date("2025-06-12"), by = "day"))
# as_of defaults to max(day) = 2025-06-12, so the partial June is dropped
nrow(filter_complete_periods(df, day, unit = "month"))
#> [1] 61
```
