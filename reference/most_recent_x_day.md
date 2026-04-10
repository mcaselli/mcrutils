# Get the date of the prior Sunday or Monday

This function returns the date of the most recent Sunday or Monday that
is on or before the current date or a specified reference date.

## Usage

``` r
most_recent_monday(ref_date = NULL)

most_recent_sunday(ref_date = NULL)
```

## Arguments

- ref_date:

  A date object or a string representing a date. Defaults to NULL, which
  uses the current date.

## Value

A Date object representing the most recent Sunday or Monday

## Examples

``` r
most_recent_monday() # Returns the most recent Monday from today
#> [1] "2026-04-06"
# Returns c("2025-12-29", "2026-01-05")
most_recent_monday(c("2026-01-04", "2026-01-05"))
#> [1] "2025-12-29" "2026-01-05"
most_recent_sunday("2024-06-15") # Returns "2024-06-09"
#> [1] "2024-06-09"
```
