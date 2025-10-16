# mcrutils (development version)

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
