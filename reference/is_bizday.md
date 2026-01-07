# Check if Date is a Business Day in a Given Calendar

This function checks if the provided date(s) are business days according
to the specified QuantLib calendar.

## Usage

``` r
is_bizday(date, calendar)
```

## Arguments

- date:

  A vector of dates (Date object or coercible with
  [`as.Date()`](https://rdrr.io/r/base/as.Date.html)).

- calendar:

  (character) A QuantLib calendar id (the vector
  [qlcal::calendars](https://rdrr.io/pkg/qlcal/man/calendars.html) lists
  all valid options).

## Value

A logical vector indicating whether each date is a business day in the
specified calendar.

## See also

[`qlcal::calendars()`](https://rdrr.io/pkg/qlcal/man/calendars.html),
[`qlcal::isBusinessDay()`](https://rdrr.io/pkg/qlcal/man/isBusinessDay.html)

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
# July 4, 2024 is a US holiday, but not a UK holiday
is_bizday(c("2024-07-04", "2024-07-05"), "UnitedStates")
#> [1] FALSE  TRUE
is_bizday(c("2024-07-04", "2024-07-05"), "UnitedKingdom")
#> [1] TRUE TRUE
```
