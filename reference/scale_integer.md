# Continuous position scales with integer-friendly breaks

`scale_x_integer()` and `scale_y_integer()` are convenience wrappers
around
[`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
and
[`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
that prefer clean integer breaks (for example avoiding 2.5-step breaks
on ranges around 10).

## Usage

``` r
scale_x_integer(n_breaks = 5, ...)

scale_y_integer(n_breaks = 5, ...)
```

## Arguments

- n_breaks:

  Approximate number of integer-preferred breaks, passed to
  [`base::pretty()`](https://rdrr.io/r/base/pretty.html) as `n`.

- ...:

  Named arguments passed through to
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
  or
  [`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html),
  except `breaks`.

  Breaks are generated using `floor(pretty(x, n_breaks))`. If you need
  to supply `breaks` directly, use
  [`ggplot2::scale_x_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
  or
  [`ggplot2::scale_y_continuous()`](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
  instead.

## Value

A ggplot2 scale object.
