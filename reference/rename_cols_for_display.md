# Rename columns for display

Convert snake_case-like column names to title-style labels, optionally
preserving selected acronyms in uppercase.

## Usage

``` r
rename_cols_for_display(data, all_caps = character())
```

## Arguments

- data:

  A data frame or tibble.

- all_caps:

  A character vector of tokens to preserve in uppercase. Matching is
  case-insensitive and applied to whole words after formatting.

## Value

A data frame with renamed columns.

## Examples

``` r
data.frame(volume_py = 1, abc_units = 2) |>
  rename_cols_for_display(all_caps = c("PY", "ABC"))
#>   Volume PY ABC Units
#> 1         1         2
```
