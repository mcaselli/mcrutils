# Normalize character or factor columns containing logical data to logical type

Normalize character or factor columns containing logical data to logical
type

## Usage

``` r
normalize_logicals(data, quiet = FALSE)
```

## Arguments

- data:

  A data frame or tibble

- quiet:

  If `TRUE`, suppresses messages about the columns being converted

## Value

A data frame or tibble with the specified columns converted to logical
type

## Details

uses
[`detect_hidden_logicals()`](https://mcaselli.github.io/mcrutils/reference/detect_hidden_logicals.md)
to find columns that are character or factor but contain logical values.
Converts these columns to logical type using
[`base::as.logical()`](https://rdrr.io/r/base/logical.html).
