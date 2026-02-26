# Add CAGR columns across groups and time with robust ordering and diagnostics

`mutate_cagrs()` computes the CAGR (Compound Annual Growth Rate) for a
numeric value column for one or more specified lag periods and appends
the resulting columns to a data frame. The function performs grouping
(if specified) and sorting of `data`, but no aggregation.

The function is designed for tidyverse workflows.

## Usage

``` r
mutate_cagrs(
  data,
  values,
  time_var,
  group_vars = NULL,
  periods = c(2:4),
  names = "{.col}_{.fn}",
  validate = TRUE,
  quiet = FALSE
)
```

## Arguments

- data:

  A data frame.

- values:

  \<[`data-masked`](https://dplyr.tidyverse.org/reference/dplyr_data_masking.html)\>
  column containing the numeric values on which CAGRs will be computed.

- time_var:

  \<[`data-masked`](https://dplyr.tidyverse.org/reference/dplyr_data_masking.html)\>
  Unquoted column name indicating the time ordering used to pair values
  and their lags. It should be sortable in chronological order when used
  in
  [`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).

- group_vars:

  \<[`tidy-select`](https://dplyr.tidyverse.org/reference/dplyr_tidy_select.html)\>
  Optional **tidyselect expression** evaluated in `data` that selects
  grouping columns, e.g. `c(region, brand)`,
  `dplyr::starts_with("geo_")`, or `NULL` for no grouping. Internally,
  this is resolved to concrete column names via
  [`passed_colnames()`](https://mcaselli.github.io/mcrutils/reference/passed_colnames.md).

- periods:

  Integer vector of lag distances (period lengths) for which to compute
  CAGRs. Defaults to `c(2, 3, 4)`.

- names:

  A glue-style naming pattern for output columns. Defaults to
  `"{.col}_{.fn}"`. The function names are of the form `"cagr_<n>"`.

- validate:

  Logical; if `TRUE`, performs diagnostics (duplicates and, when
  feasible, gaps).

- quiet:

  Logical; if `TRUE`, suppresses `cli` warnings/messages.

## Value

A data frame (a tibble if `data` is a tibble) with CAGR columns added
(one per requested period).

## Details

**Ordering of `time_var`**

CAGR compares each value to its lagged value at a fixed lag of `n` rows
after grouping and sorting. To produce correct pairings, the data must
be sorted consistently within each group. `mutate_cagrs()` simply
arranges rows by any grouping columns (if provided) and then by
`time_var`. To produce correct results, `time_var` must yield a
chronological order when sorted with
[`arrange()`](https://dplyr.tidyverse.org/reference/arrange.html).

For example, numeric years (e.g., 2020, 2021) or `Date` objects will
work as expected.

However, if `time_var` is an unordered factor or arbitrary character
labels (e.g., "Q1-2020", "Q2-2020"), the sorting will be lexicographic
and may not reflect the intended chronological order, leading to
incorrect CAGR calculations.

Check that `data |> arrange(group_vars, time_var)` produces the intended
chronological order before calling `mutate_cagrs()`. If the order is not
correct, consider transforming `time_var` to a well-behaved format
(e.g., numeric year, `Date`, ordered factor) upstream for accurate
results. Note gap detection is only supported for numeric and date
types, so providing `time_var` in those types is preferred.

**Diagnostics**

When `validate = TRUE`, the function performs:

- **Duplicate detection**: If duplicate (group, time) rows exist,
  lag-based calculations will be ambiguous. `mutate_cagrs()` will error
  if duplicates are detected. To resolve, identify the source of
  duplicates and consider aggregating (e.g.,
  [`dplyr::summarise()`](https://dplyr.tidyverse.org/reference/summarise.html))
  to one row per (group, time) before calling `mutate_cagrs()`.

- **Gap detection**: A light-weight heuristic flags irregular spacing
  only when `time_var` is numeric/integer or date/datetime. For other
  types, gap detection is skipped.

**Computation**

Each requested period `n` produces a column named via the `names`
pattern (default: `"{.col}_{.fn}"`, where `{.fn}` is `"cagr_<n>"`).
CAGRs are computed as \$\$\left(\frac{x_t}{x\_{t-n}}\right)^{1/n} -
1\$\$ using a safe implementation that returns `NA_real_` when either
value is missing or when the lagged base is non-positive.

**Caveats**

- **Multiple rows per (group, time)**: A single row per period per group
  is required to computing CAGRs. Duplicate (group, time) rows trigger
  an error unless `validate = FALSE`.

- **Zeros and negatives**: If the lagged base is `<= 0`, the
  corresponding CAGR is `NA_real_`. Consider an offset (domain-specific)
  or filtering non-positive values if appropriate.

- **Time variable**: This function assumes `time_var` is already a
  well-behaved, sortable representation of time. If it is not (e.g.,
  factor or arbitrary character labels), convert it upstream (e.g., to
  numeric year, `Date`) for correct results.

- **Gaps in time**: CAGRs are computed by comparing values at n-lagged
  rows. If the gaps are present in the data, the time period between
  those rows may not match the intended `n` periods, leading to
  incorrect CAGR values. If `validate = TRUE`, the function performs a
  heuristic gap detection for `time_var` of numeric and date types, and
  will error if a gap is found. For other types, a warning is issued
  that gap detection was skipped, and the function proceeds with the
  calculation. It is the user's responsibility to ensure that the time
  variable is consistent and free of gaps for accurate CAGR
  calculations.

- **Performance**: For large grouped data, consider pre-aggregating and
  minimizing the number of requested `periods`.

## Recommended Workflow

1.  Ensure at most one row per (group, time). If not, aggregate with
    [`dplyr::summarise()`](https://dplyr.tidyverse.org/reference/summarise.html)
    before computing CAGRs.

2.  Provide a well-behaved, sortable `time_var` (e.g., numeric year,
    `Date`).

3.  Inspect `cli` warnings for duplicates or (when applicable) gaps;
    address upstream as needed.

4.  Compute CAGRs with one call to `mutate_cagrs()` and use the
    resulting columns for plotting, dashboards, or further analysis.

## See also

[`calculate_cagr_safe()`](https://mcaselli.github.io/mcrutils/reference/calculate_cagr_safe.md)
for the underlying safe CAGR calculation;
[`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html),
[`dplyr::arrange()`](https://dplyr.tidyverse.org/reference/arrange.html),
[`dplyr::across()`](https://dplyr.tidyverse.org/reference/across.html)
for related tidyverse ops;
[`passed_colnames()`](https://mcaselli.github.io/mcrutils/reference/passed_colnames.md)
for resolving tidyselect expressions to names.

## Examples

``` r
# --- Basic yearly CAGR by region ---
df <- data.frame(
  region = rep(c("APAC", "EMEA"), each = 5),
  year = rep(2018:2022, times = 2),
  items = c(
    100, 110, 121, 133, 146,
    90, 95, 104, 115, 120
  )
)

df_cagr <- mutate_cagrs(
  data = df,
  values = items,
  time_var = year,
  group_vars = c(region),
  periods = c(2, 4)
)


# --- Weekly date (well-behaved as Date) ---
df_wk <- data.frame(
  week = as.Date(c("2026-03-09", "2026-03-16", "2026-03-23", "2026-03-30")),
  items = c(100, 105, 102, 108)
)
df_wk_cagr <- mutate_cagrs(
  data = df_wk,
  values = items,
  time_var = week
)
```
