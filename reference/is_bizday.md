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
#> [23] "Croatia"                        "CzechRepublic"                 
#> [25] "Denmark"                        "Finland"                       
#> [27] "France"                         "France/Exchange"               
#> [29] "Germany"                        "Germany/FrankfurtStockExchange"
#> [31] "Germany/Xetra"                  "Germany/Eurex"                 
#> [33] "Germany/Euwax"                  "HongKong"                      
#> [35] "Hungary"                        "Iceland"                       
#> [37] "India"                          "Indonesia"                     
#> [39] "Israel"                         "Israel/TASE"                   
#> [41] "Israel/SHIR"                    "Israel/Telbor"                 
#> [43] "Italy"                          "Italy/Exchange"                
#> [45] "Japan"                          "Malta"                         
#> [47] "Mexico"                         "Montenegro"                    
#> [49] "NewZealand"                     "NewZealand/Auckland"           
#> [51] "NorthMacedonia"                 "Norway"                        
#> [53] "Null"                           "Poland"                        
#> [55] "Romania"                        "Russia"                        
#> [57] "SaudiArabia"                    "Serbia"                        
#> [59] "Singapore"                      "Slovakia"                      
#> [61] "Slovenia"                       "SouthAfrica"                   
#> [63] "SouthKorea"                     "SouthKorea/KRX"                
#> [65] "Sweden"                         "Switzerland"                   
#> [67] "Taiwan"                         "Thailand"                      
#> [69] "Turkey"                         "Ukraine"                       
#> [71] "UnitedKingdom"                  "UnitedKingdom/Exchange"        
#> [73] "UnitedKingdom/Metals"           "Uzbekistan"                    
#> [75] "WeekendsOnly"                  
# July 4, 2024 is a US holiday, but not a UK holiday
is_bizday(c("2024-07-04", "2024-07-05"), "UnitedStates")
#> [1] FALSE  TRUE
is_bizday(c("2024-07-04", "2024-07-05"), "UnitedKingdom")
#> [1] TRUE TRUE
```
