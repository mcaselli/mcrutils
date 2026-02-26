# (Internal) Detect duplicates in (group, time)

(Internal) Detect duplicates in (group, time)

## Usage

``` r
.check_duplicates_plain(data, group_cols, time_col)
```

## Arguments

- data:

  A data frame (already grouped or not).

- group_cols:

  Character vector of grouping column names (may be empty).

- time_col:

  Character scalar, the name of the time column.

## Value

Logical; TRUE if duplicates exist, else FALSE.
