# Calculate the Number of Business Days in Months, Quarters, etc

This function calculates the number of business days in each periodic
interval (e.g., month, quarter) between two dates, using specified
QuantLib calendars for holiday definitions.

## Usage

``` r
periodic_bizdays(from, to, by = "month", quantlib_calendars = "UnitedStates")
```

## Arguments

- from, to:

  start and end dates. Date object or something coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html).

- by:

  periodicity, passed to
  [`seq.Date()`](https://rdrr.io/r/base/seq.Date.html) (e.g., "month",
  "quarter", "year"). See
  [`seq.Date()`](https://rdrr.io/r/base/seq.Date.html) for more options.

- quantlib_calendars:

  (character) A vector of QuantLib calendar ids (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

## Value

a tibble with columns:

- calendar:

  the QuantLib calendar used

- start:

  the start date of the period

- end:

  the end date of the period

- business_days:

  the number of business days in the period, according to the calendar

## Examples

``` r
periodic_bizdays(
  from = as.Date("2023-01-01"),
  to = as.Date("2023-12-31"),
  by = "month",
  quantlib_calendars = c("UnitedStates", "UnitedKingdom")
)
#> # A tibble: 24 × 4
#>    calendar     start      end        business_days
#>    <chr>        <date>     <date>             <int>
#>  1 UnitedStates 2023-01-01 2023-01-31            20
#>  2 UnitedStates 2023-02-01 2023-02-28            19
#>  3 UnitedStates 2023-03-01 2023-03-31            23
#>  4 UnitedStates 2023-04-01 2023-04-30            20
#>  5 UnitedStates 2023-05-01 2023-05-31            22
#>  6 UnitedStates 2023-06-01 2023-06-30            21
#>  7 UnitedStates 2023-07-01 2023-07-31            20
#>  8 UnitedStates 2023-08-01 2023-08-31            23
#>  9 UnitedStates 2023-09-01 2023-09-30            20
#> 10 UnitedStates 2023-10-01 2023-10-31            21
#> # ℹ 14 more rows
```
