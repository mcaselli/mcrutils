# mcrutils (development version)

## New

- `bizday_of_period()` to compute the business day of a date within a given
period (e.g. month, quarter).

- `load_calendars()` a convenience wrapper around 
`bizdays::load_quantlib_calendars()` that takes a vector of dates and a vector 
of calendars and loads the calendars for the full years spanning the specified 
dates.

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
