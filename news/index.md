# Changelog

## mcrutils (development version)

### New

- Period-completeness toolkit for reporting on partial periods:
  - [`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md)
    tests whether the period (week/month/quarter/year) containing each
    date is complete as of a cutoff date. Completeness is business-day
    aware via a QuantLib calendar (default `"WeekendsOnly"`); pass a
    national calendar such as `"UnitedStates"` for holiday accuracy, or
    `"Null"` for pure calendar-day semantics.
  - [`period_start_date()`](https://mcaselli.github.io/mcrutils/reference/period_bounds.md)
    and
    [`period_end_date()`](https://mcaselli.github.io/mcrutils/reference/period_bounds.md)
    return the canonical first and last calendar day of the period
    containing each date.
  - [`filter_complete_periods()`](https://mcaselli.github.io/mcrutils/reference/filter_complete_periods.md)
    keeps only rows whose period is complete; `as_of` defaults to the
    maximum of the date column.
  - [`last_complete_period_start()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md)
    and
    [`last_complete_period_end()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md)
    return the boundaries of the most recent complete period as of a
    cutoff.
  - [`scale_alpha_logical()`](https://mcaselli.github.io/mcrutils/reference/scale_alpha_logical.md),
    a ggplot2 alpha scale for fading incomplete periods (pairs with
    [`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md)).
- Completeness uses an inclusive convention: a period is complete once
  its end date is reached (not strictly after it). For pure calendar-day
  semantics use `calendar = "Null"` (the QuantLib id is `"Null"`, not
  `"NullCalendar"`). `NA` dates propagate to `NA` (and are dropped by
  [`filter_complete_periods()`](https://mcaselli.github.io/mcrutils/reference/filter_complete_periods.md)).
- [`period_is_complete()`](https://mcaselli.github.io/mcrutils/reference/period_is_complete.md),
  [`last_complete_period_start()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md),
  and
  [`last_complete_period_end()`](https://mcaselli.github.io/mcrutils/reference/last_complete_period.md)
  require an explicit `as_of`; there is no wall-clock default, so
  completeness is never judged against the current date unless you ask
  for it (pass [`Sys.Date()`](https://rdrr.io/r/base/Sys.time.html) to
  opt in).
  [`filter_complete_periods()`](https://mcaselli.github.io/mcrutils/reference/filter_complete_periods.md)
  still defaults `as_of` to the maximum of its date column.

### Behavior changes

- [`most_recent_monday()`](https://mcaselli.github.io/mcrutils/reference/most_recent_x_day.md)
  /
  [`most_recent_sunday()`](https://mcaselli.github.io/mcrutils/reference/most_recent_x_day.md):
  the `ref_date` argument is renamed `as_of`, matching the
  period-completeness functions (both name the date that state is
  evaluated as of). The default (current date) is unchanged and
  positional calls are unaffected, but callers passing `ref_date =` by
  name must switch to `as_of =`.

## mcrutils 0.0.0.9013

### Behavior changes

- [`rename_cols_for_display()`](https://mcaselli.github.io/mcrutils/reference/rename_cols_for_display.md)
  now uses minor-word-aware title casing (via
  [`snakecase::to_title_case()`](https://rdrr.io/pkg/snakecase/man/caseconverter.html))
  instead of
  [`stringr::str_to_title()`](https://stringr.tidyverse.org/reference/case.html).
  Short connecting words such as “of”, “to”, “per”, and “vs” stay
  lowercase (e.g. `new_to_market` -\> “New to Market”). Acronym
  preservation via `all_caps` is unchanged. Adds a dependency on
  `snakecase`.

## mcrutils 0.0.0.9012

### Bug fixes

- [`bizdays_between()`](https://mcaselli.github.io/mcrutils/reference/bizdays_between.md):
  `include_first` and `include_last` arguments were ignored and always
  treated as `TRUE`. They are now forwarded correctly to
  [`qlcal::businessDaysBetween()`](https://rdrr.io/pkg/qlcal/man/businessDaysBetween.html).

## mcrutils 0.0.0.9011

### New

- [`scale_x_integer()`](https://mcaselli.github.io/mcrutils/reference/scale_integer.md)
  and
  [`scale_y_integer()`](https://mcaselli.github.io/mcrutils/reference/scale_integer.md)
  for continuous ggplot scales that favor integer break labels.
- [`rename_cols_for_display()`](https://mcaselli.github.io/mcrutils/reference/rename_cols_for_display.md)
  to convert snake_case-like column names to title-style labels with
  optional acronym preservation.

## mcrutils 0.0.0.9010

### New

- [`mutate_cagrs()`](https://mcaselli.github.io/mcrutils/reference/mutate_cagrs.md)
  to compute compound annual growth rates (CAGRs) for specified columns
  in a data frame.
- [`passed_colnames()`](https://mcaselli.github.io/mcrutils/reference/passed_colnames.md),
  a helper function that evaluates a tidyselect expression in the
  context of a data frame and returns the names of the columns that were
  selected.

## mcrutils 0.0.0.9009

### New

- [`most_recent_sunday()`](https://mcaselli.github.io/mcrutils/reference/most_recent_x_day.md)
  and
  [`most_recent_monday()`](https://mcaselli.github.io/mcrutils/reference/most_recent_x_day.md)
  to return the date of the most recent Sunday or Monday that is on or
  before the current date or a specified reference date.

## mcrutils 0.0.0.9008

### New

- [`bizday_of_period()`](https://mcaselli.github.io/mcrutils/reference/bizday_of_period.md)
  to compute the business day of a date within a given period (e.g. date
  xxx is the 3rd business day of the month according to the UnitedStates
  QuantLib calendar)

- [`is_bizday()`](https://mcaselli.github.io/mcrutils/reference/is_bizday.md),
  [`bizdays_between()`](https://mcaselli.github.io/mcrutils/reference/bizdays_between.md)
  which wrap similar `qlcal` functions, but allow evaluation in a
  specified QuantLib calendar without making persistent changes to the
  globally configured calendar.

- [`with_calendar()`](https://mcaselli.github.io/mcrutils/reference/set_cal.md)
  and
  [`local_calendar()`](https://mcaselli.github.io/mcrutils/reference/set_cal.md)
  which facilitate temporary changes to the configured `qlcal` QuantLib
  calendar a’la `with_*()` and `local_*()` functions from the `withr`
  package.

- [`set_calendar()`](https://mcaselli.github.io/mcrutils/reference/set_cal.md)
  which changes the globally configured qlcal QuantLib calendar, but
  only if the specified calendar is valid and different from the
  currently configured calendar.

### Changed

- (internal) removed `bizdays` dependency, now using `qlcal` for
  business day functions

## mcrutils 0.0.0.9007

### New

- [`periodic_bizdays()`](https://mcaselli.github.io/mcrutils/reference/periodic_bizdays.md)
  function to calculate business days between two dates with a specified
  periodicity (e.g., weekly, monthly), using RQuantLib calendars for
  holiday definitions. A convenience wrapper around `bizdays::bizdays()`

## mcrutils 0.0.0.9006

### New

- [`plot_accounts_by_status()`](https://mcaselli.github.io/mcrutils/reference/plot_accounts_by_status.md)
  can now display lost accounts in two ways. Default behavior
  `lost = "detailed"` shows temporarily_lost and termially_lost
  separately (as in prior versions), while `lost = "simple"` combines
  them into a single lost category.

### Changed

- [`auto_dt()`](https://mcaselli.github.io/mcrutils/reference/auto_dt.md)
  now includes copy and download buttons by default. Set
  `buttons = FALSE` to suppress
