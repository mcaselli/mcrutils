# creates a datatable with some automatic formatting

This function creates a datatable with automatic formatting for
percentage, currency, and numeric columns, using
[`guess_col_fmts()`](https://mcaselli.github.io/mcrutils/reference/guess_col_fmts.md)
to determine which columns are percentages, currency, or numeric.

## Usage

``` r
auto_dt(
  data,
  pct_digits = 1,
  currency_digits = 0,
  numeric_digits = 0,
  buttons = TRUE,
  ...
)
```

## Arguments

- data:

  a data frame to be displayed as a datatable

- pct_digits:

  number of digits to display for percentage columns

- currency_digits:

  number of digits to display for currency columns

- numeric_digits:

  number of digits to display for numeric columns

- buttons:

  logical, if TRUE include buttons for copy, csv, and excel downloads

- ...:

  additional arguments passed to
  [`guess_col_fmts()`](https://mcaselli.github.io/mcrutils/reference/guess_col_fmts.md)

## Value

a datatable with formatted columns, filter at top, and no rownames
