# Guesses appropriate format class for each numeric column in a data frame

Using column names, this function classifies numeric columns into three
classes: percentage, currency, and numeric. It uses the presence of
specific flags in the column names to determine the class of each
column. Numeric columns whose names don't contain any `pct_flags` or
`curr_flags` are classified as numeric.

## Usage

``` r
guess_col_fmts(
  data,
  pct_flags = c("frac", "pct", "percent"),
  curr_flags = c("revenue", "asp", "cogs")
)
```

## Arguments

- data:

  a data frame

- pct_flags:

  a character vector of flags to identify percentage columns

- curr_flags:

  a character vector of flags to identify currency columns

## Value

a list with three character vectors: numeric, pct, currency, with the
names of the columns in each class
