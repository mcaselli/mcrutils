
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mcrutils

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/mcaselli/mcrutils/graph/badge.svg)](https://app.codecov.io/gh/mcaselli/mcrutils)
[![R-CMD-check](https://github.com/mcaselli/mcrutils/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mcaselli/mcrutils/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of mcrutils is to …

## Installation

You can install the development version of mcrutils from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("mcaselli/mcrutils")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(mcrutils)

df <- data.frame(
  logical_char = c("T", "F", "T"),
  logical_factor = factor(c("TRUE", "FALSE", "TRUE")),
  non_logical_char = c("a", "b", "c"),
  non_logical_factor = factor(c("x", "y", "z")),
  mixed_char = c("T", "F", "a"),
  mixed_factor = factor(c("TRUE", "FALSE", "x")),
  numeric_col = c(1.1, 2.2, 3.3),
  stringsAsFactors = FALSE
)

normalize_logicals(df)
#> Converted "logical_char" and "logical_factor" columns to logical.
#>   logical_char logical_factor non_logical_char non_logical_factor mixed_char
#> 1         TRUE           TRUE                a                  x          T
#> 2        FALSE          FALSE                b                  y          F
#> 3         TRUE           TRUE                c                  z          a
#>   mixed_factor numeric_col
#> 1         TRUE         1.1
#> 2        FALSE         2.2
#> 3            x         3.3
```
