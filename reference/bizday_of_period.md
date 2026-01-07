# Find the business day of the period for a given date and calendar

Convenience wrapper around
[`qlcal::businessDaysBetween()`](https://rdrr.io/pkg/qlcal/man/businessDaysBetween.html)
that calculates what business day a date is of a month, quarter, or
year, with the first business day ofthe period being 1, the second 2,
etc. It uses a specified QuantLib calendar for holiday definitions.

## Usage

``` r
bizday_of_period(date, calendar, period = c("month", "quarter", "year"))
```

## Arguments

- date:

  A vector of dates (Date object or coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- calendar:

  (character) A QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

- period:

  The period type: "month", "quarter", or "year"

## Value

An integer representing the business day of the period for the given
date and calendar.

## Details

NOTE: To ensure predictable, intuitive results, input dates should
generally be pre-adjusted to business days using a transparent and
deterministic method like
[`adjust_to_bizday()`](https://mcaselli.github.io/mcrutils/reference/adjust_to_bizday.md),
[`qlcal::adjust()`](https://rdrr.io/pkg/qlcal/man/adjust.html) or
similar, because adjustment may cause a date to shift from one period to
another, e.g. adjustment of a weekend/holiday to the next business day
may cause the date to shift to the next month.

## See also

[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html),
[`qlcal::businessDaysBetween()`](https://rdrr.io/pkg/qlcal/man/businessDaysBetween.html)
[`adjust_to_bizday()`](https://mcaselli.github.io/mcrutils/reference/adjust_to_bizday.md)

## Examples

``` r
# valid calendars
qlcal::calendars
#>  [1] "TARGET"                         "UnitedStates"                  
#>  [3] "UnitedStates/LiborImpact"       "UnitedStates/NYSE"             
#>  [5] "UnitedStates/GovernmentBond"    "UnitedStates/NERC"             
#>  [7] "UnitedStates/FederalReserve"    "UnitedStates/SOFR"             
#>  [9] "Argentina"                      "Australia"                     
#> [11] "Australia/ASX"                  "Austria"                       
#> [13] "Austria/Exchange"               "Bespoke"                       
#> [15] "Botswana"                       "Brazil"                        
#> [17] "Brazil/Exchange"                "Canada"                        
#> [19] "Canada/TSX"                     "Chile"                         
#> [21] "China"                          "China/IB"                      
#> [23] "CzechRepublic"                  "Denmark"                       
#> [25] "Finland"                        "France"                        
#> [27] "France/Exchange"                "Germany"                       
#> [29] "Germany/FrankfurtStockExchange" "Germany/Xetra"                 
#> [31] "Germany/Eurex"                  "Germany/Euwax"                 
#> [33] "HongKong"                       "Hungary"                       
#> [35] "Iceland"                        "India"                         
#> [37] "Indonesia"                      "Israel"                        
#> [39] "Italy"                          "Italy/Exchange"                
#> [41] "Japan"                          "Mexico"                        
#> [43] "NewZealand"                     "Norway"                        
#> [45] "Null"                           "Poland"                        
#> [47] "Romania"                        "Russia"                        
#> [49] "SaudiArabia"                    "Singapore"                     
#> [51] "Slovakia"                       "SouthAfrica"                   
#> [53] "SouthKorea"                     "SouthKorea/KRX"                
#> [55] "Sweden"                         "Switzerland"                   
#> [57] "Taiwan"                         "Thailand"                      
#> [59] "Turkey"                         "Ukraine"                       
#> [61] "UnitedKingdom"                  "UnitedKingdom/Exchange"        
#> [63] "UnitedKingdom/Metals"           "WeekendsOnly"                  

# July 4 is a US holiday, but not a UK holiday
bizday_of_period("2024-07-05", "UnitedStates", period = "month")
#> [1] 4
bizday_of_period("2024-07-05", "UnitedKingdom", period = "month")
#> [1] 5

library(dplyr)
#> 
#> Attaching package: ‘dplyr’
#> The following objects are masked from ‘package:stats’:
#> 
#>     filter, lag
#> The following objects are masked from ‘package:base’:
#> 
#>     intersect, setdiff, setequal, union

tibble(
  date = seq(as.Date("2025-05-29"), as.Date("2025-06-03"), by = "day"),
) |>
  mutate(
    day_of_week = weekdays(date),
    adjusted_date = adjust_to_bizday(date, "UnitedStates"),
    bizday_of_month = bizday_of_period(adjusted_date, "UnitedStates", period = "month"),
    bizday_of_year = bizday_of_period(adjusted_date, "UnitedStates", period = "year")
  )
#> # A tibble: 6 × 5
#>   date       day_of_week adjusted_date bizday_of_month bizday_of_year
#>   <date>     <chr>       <date>                  <dbl>          <dbl>
#> 1 2025-05-29 Thursday    2025-05-29                 20            103
#> 2 2025-05-30 Friday      2025-05-30                 21            104
#> 3 2025-05-31 Saturday    2025-06-02                  1            105
#> 4 2025-06-01 Sunday      2025-06-02                  1            105
#> 5 2025-06-02 Monday      2025-06-02                  1            105
#> 6 2025-06-03 Tuesday     2025-06-03                  2            106
```
