# Get the column names passed to a data-masked expression

This is a helper function that evaluates a tidyselect expression in the
context of a data frame and returns the names of the columns that were
selected.

## Usage

``` r
passed_colnames(data, expr)
```

## Arguments

- data:

  A data frame in which to evaluate the expression.

- expr:

  A tidyselect expression (usually a quosure from
  [`rlang::enquo()`](https://rlang.r-lib.org/reference/enquo.html)) that
  specifies which columns to select.

## Value

A character vector of column names that were selected by the expression.

The function returns `character(0)` when NULL is passed, which can
signal no columns were selected. (note `group_by(all_of(character(0)))`
conveniently does nothing.

The function will error if the expression selects columns that are not
present in the data frame.

## Details

This is useful in a dplyr-style function where you want the user to be
able to specify no, one, or multiple columns using tidyselect syntax,
and you want to get the names of those columns for further processing.

## Examples

``` r
library(dplyr)

averages <- function(data, values, groups = NULL) {
  group_cols <- passed_colnames(data, rlang::enquo(groups))

  data |>
    group_by(across(all_of(group_cols))) |>
    summarise(avg = mean({{ values }}), .groups = "drop")
}

mtcars |> averages(values = mpg, groups = c(cyl, gear))
#> # A tibble: 8 × 3
#>     cyl  gear   avg
#>   <dbl> <dbl> <dbl>
#> 1     4     3  21.5
#> 2     4     4  26.9
#> 3     4     5  28.2
#> 4     6     3  19.8
#> 5     6     4  19.8
#> 6     6     5  19.7
#> 7     8     3  15.0
#> 8     8     5  15.4
mtcars |> averages(values = mpg, groups = cyl)
#> # A tibble: 3 × 2
#>     cyl   avg
#>   <dbl> <dbl>
#> 1     4  26.7
#> 2     6  19.7
#> 3     8  15.1
mtcars |> averages(mpg, starts_with("c"))
#> # A tibble: 9 × 3
#>     cyl  carb   avg
#>   <dbl> <dbl> <dbl>
#> 1     4     1  27.6
#> 2     4     2  25.9
#> 3     6     1  19.8
#> 4     6     4  19.8
#> 5     6     6  19.7
#> 6     8     2  17.2
#> 7     8     3  16.3
#> 8     8     4  13.2
#> 9     8     8  15  
mtcars |> averages(values = mpg, groups = NULL)
#> # A tibble: 1 × 1
#>     avg
#>   <dbl>
#> 1  20.1
```
