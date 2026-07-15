# Is the period containing each date complete as of a cutoff?

**\[experimental\]**

For each date in `date`, tests whether the period containing it is
complete as of `as_of` (typically `max(order_date)` or a report end
date). A period is complete once no business days remain after `as_of`
up to and including the period end, evaluated in `calendar`.

Choosing `calendar` selects the completeness policy:

- `"WeekendsOnly"` (default) treats Mon-Fri as working days with no
  holidays – a period is complete once only weekends remain.

- A national calendar such as `"UnitedStates"` additionally treats
  holidays as non-working, giving holiday-accurate completeness.

- `"Null"` treats every calendar day as a working day, so completeness
  reduces to "every calendar day of the period has elapsed"
  (`period_end_date(date) <= as_of`).

See [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) for
valid ids.

## Usage

``` r
period_is_complete(
  date,
  unit = "month",
  as_of,
  calendar = "WeekendsOnly",
  week_start = getOption("lubridate.week.start", 7)
)
```

## Arguments

- date:

  A vector of dates (Date or coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)); each value
  identifies the period to test.

- unit:

  Period size, one of `"week"`, `"month"`, `"quarter"`, or `"year"`.

- as_of:

  Reference cutoff date (Date or coercible), length 1 or the length of
  `date`. Required—there is no default, so completeness is never judged
  silently against the current date. Pass
  [`max()`](https://rdrr.io/r/base/Extremes.html) of your data's date
  column for completeness relative to how current the data is, or
  [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html) for the current
  date.

- calendar:

  (character) A QuantLib calendar id (see
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html)).
  Defaults to `"WeekendsOnly"`.

- week_start:

  Integer 1-7 giving the first day of the week (only used when
  `unit = "week"`). Defaults to `getOption("lubridate.week.start", 7)`.

## Value

A logical vector the same length as `date`.

## See also

[`filter_complete_periods()`](https://mcaselli.github.io/mcrutils/reference/filter_complete_periods.md),
[`last_complete_period_end()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md),
[`scale_alpha_logical()`](https://mcaselli.github.io/mcrutils/reference/scale_alpha_logical.md),
[`period_end_date()`](https://mcaselli.github.io/mcrutils/reference/period_bounds.md)

## Examples

``` r
# As of 2025-05-30 (a Friday), April and May are complete under the
# weekends-only calendar -- May's only remaining day, the 31st, is a Saturday --
# but June is not. Returns c(TRUE, TRUE, FALSE).
period_is_complete(
  as.Date(c("2025-04-15", "2025-05-15", "2025-06-15")),
  unit = "month",
  as_of = as.Date("2025-05-30")
)
#> [1]  TRUE  TRUE FALSE

# Pure calendar-day semantics: May is not complete until 2025-05-31 elapses.
period_is_complete(
  as.Date("2025-05-15"),
  as_of = as.Date("2025-05-30"),
  calendar = "Null"
)
#> [1] FALSE
```
