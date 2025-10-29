# mcrutils (development version)

## New
- `bizday_of_period()` to compute the business day of a date within a given
period (e.g. date xxx is the 3rd business day of the month according to the 
UnitedStates QuantLib calendar)

- `is_bizday()`, `bizdays_between()` which wrap similar `qlcal` functions, but
allow evaluation in a specified QuantLib calendar without making persistent 
changes to the globally configured calendar.

- `with_calendar()` and `local_calendar()` which facilitate temporary changes to 
the configured `qlcal` QuantLib calendar a'la `with_*()` and `local_*()` 
functions from the `withr` package.

- `set_calendar()` which changes the globally configured qlcal QuantLib calendar, 
but only if the specified calendar is valid and different from the
currently configured calendar.

## Changed

- (internal) removed `bizdays` dependency, now using `qlcal` for business day 
functions


# mcrutils 0.0.0.9007

## New

- `periodic_bizdays()` function to calculate business days between two dates
with a specified periodicity (e.g., weekly, monthly), using RQuantLib calendars
for holiday definitions. A convenience wrapper around `bizdays::bizdays()`


# mcrutils 0.0.0.9006

## New

-   `plot_accounts_by_status()` can now display lost accounts in two
    ways. Default behavior `lost = "detailed"` shows temporarily_lost
    and termially_lost separately (as in prior versions), while
    `lost = "simple"` combines them into a single lost category.

## Changed

-   `auto_dt()` now includes copy and download buttons by default. Set
    `buttons = FALSE` to suppress
