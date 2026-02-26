# Safe Compound Annual Growth Rate (CAGR)

Computes \\(x_t / x\_{t-n})^{1/n} - 1\\ with guardrails to avoid
division-by-zero and negative bases. Returns `NA_real_` when the lagged
base is missing or non-positive.

## Usage

``` r
calculate_cagr_safe(x, n_periods)
```

## Arguments

- x:

  Numeric vector of values ordered in time.

- n_periods:

  Integer; number of periods over which to compute CAGR (lag distance).

## Value

A numeric vector of CAGR values with the same length as `x`.
