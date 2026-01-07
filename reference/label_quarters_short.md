# Generate labels for quarters with year

This function generates labels for quarters in a short format, showing
the quarter and year only when it changes from the previous label,
similar to
[`scales::label_date_short()`](https://scales.r-lib.org/reference/label_date.html).

## Usage

``` r
label_quarters_short()
```

## Value

A function that takes a vector of dates and returns labels in the format
"Qx\nYYYY" or "Qn"

## Details

This should generally be used in conjunction with breaks that are the
dates of the start of a quarter, e.g. as from
[`breaks_quarters()`](https://mcaselli.github.io/mcrutils/reference/breaks_quarters.md).
