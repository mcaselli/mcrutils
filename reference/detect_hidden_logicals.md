# Find columns containing logical values stored as character or factor

Find columns containing logical values stored as character or factor

## Usage

``` r
detect_hidden_logicals(data)
```

## Arguments

- data:

  A data frame or tibble

## Value

A character vector of column names found to hold exclusively logical
data (or NA) that are typed as character or factor.

## Details

Columns are deemed to hold logical data if they contain only the values
c("T", "TRUE", "True", "true", "F", "FALSE", "False", "false", NA).
(matching [`base::as.logical()`](https://rdrr.io/r/base/logical.html))
