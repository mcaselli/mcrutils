#' Safe Compound Annual Growth Rate (CAGR)
#'
#' Computes \eqn{(x_t / x_{t-n})^{1/n} - 1} with guardrails to avoid
#' division-by-zero and negative bases. Returns \code{NA_real_} when the
#' lagged base is missing or non-positive.
#'
#' @param x Numeric vector of values ordered in time.
#' @param n_periods Integer; number of periods over which to compute CAGR
#' (lag distance).
#'
#' @return A numeric vector of CAGR values with the same length as `x`.
#' @keywords internal
calculate_cagr_safe <- function(x, n_periods) {
  lagged <- dplyr::lag(x, n_periods)
  bad <- is.na(x) | is.na(lagged) | lagged <= 0
  out <- ifelse(bad, NA_real_, (x / lagged)^(1 / n_periods) - 1)
  as.numeric(out)
}


#' (Internal) Detect duplicates in (group, time)
#'
#' @param data A data frame (already grouped or not).
#' @param group_cols Character vector of grouping column names (may be empty).
#' @param time_col Character scalar, the name of the time column.
#'
#' @return Logical; TRUE if duplicates exist, else FALSE.
#' @keywords internal
.check_duplicates_plain <- function(data, group_cols, time_col) {
  if (length(group_cols) == 0) {
    dup <- dplyr::count(data, dplyr::across(dplyr::all_of(time_col)), name = "n")
  } else {
    dup <- dplyr::count(
      data,
      dplyr::across(dplyr::all_of(group_cols)),
      dplyr::across(dplyr::all_of(time_col)),
      name = "n"
    )
  }
  any(dup$n > 1)
}


# (Internal) Heuristic gap detection with scale-aware tolerance
# - Dates/POSIXt: tolerance scales with the median/common step (default 10%) and at least 1 day
# - Numeric: strict by default (no tolerance), but configurable
# - Unsupported types: return NA (caller decides how to handle)
.detect_gaps <- function(
  v,
  rel_tol_date = 0.10, # 10% of step for Date/POSIXt
  min_abs_tol_date = 1, # at least 1 day for Date/POSIXt
  rel_tol_numeric = 0.00, # 0% for pure numeric (strict)
  min_abs_tol_numeric = 0 # no absolute tolerance for numeric by default
) {
  # Normalize input to numeric and choose tolerance mode
  if (inherits(v, "Date")) {
    v_num <- as.numeric(v) # days
    rel_tol <- rel_tol_date
    min_abs_tol <- min_abs_tol_date
  } else if (inherits(v, c("POSIXct", "POSIXlt"))) {
    v_num <- as.numeric(as.Date(v)) # days
    rel_tol <- rel_tol_date
    min_abs_tol <- min_abs_tol_date
  } else if (is.numeric(v)) {
    v_num <- v
    rel_tol <- rel_tol_numeric
    min_abs_tol <- min_abs_tol_numeric
  } else {
    # Unsupported types (character/factor/other): signal "unknown" with NA
    return(NA)
  }

  v_num <- v_num[!is.na(v_num)]
  if (length(v_num) < 2) {
    return(FALSE)
  }

  diffs <- base::diff(base::sort(base::unique(v_num)))
  if (length(diffs) == 0) {
    return(FALSE)
  }

  # Common step: mode of diffs; if tie, fallback to median
  tab <- base::table(diffs)
  max_freq <- max(tab)
  common_steps <- as.numeric(names(tab)[tab == max_freq])
  common_step <- if (length(common_steps) == 1L) common_steps else stats::median(diffs, na.rm = TRUE)

  # Scale-aware tolerance (relative to step) with a minimum absolute tolerance
  tol <- max(min_abs_tol, common_step * rel_tol)

  # Flag only when the step exceeds the threshold
  any(diffs > (common_step + tol))
}


#' Add CAGR columns across groups and time with robust ordering and diagnostics
#'
#' @description
#' `mutate_cagrs()` appends one or more CAGR (Compound Annual Growth Rate)
#' columns to a data frame, computed for a numeric value column within optional
#' groups and ordered by a specified time variable. The function is designed
#' for tidyverse workflows and expects the `time_var` to be well-behaved and
#' sortable (e.g., numeric/integer year, `Date`, `POSIXct`).
#'
#' @details
#' **Ordering**
#'
#' CAGR compares each value to its lagged value at a fixed lag `n`. To produce
#' correct pairings, the data must be sorted consistently within each group.
#' `mutate_cagrs()` simply arranges rows by any grouping columns (if provided)
#' and then by `time_var`. It assumes `time_var` orders chronologically when
#' sorted (e.g., numeric years or dates). If `time_var` is not sortable in a
#' chronological sense (e.g., a factor or arbitrary character labels),
#' please coerce it upstream into an appropriately sortable ordered
#' representation.
#'
#' **Diagnostics**
#'
#' When `validate = TRUE`, the function performs:
#'
#' - **Duplicate detection**: If duplicate (group, time) rows exist, lag-based
#'   calculations can be ambiguous. A `cli` warning is issued. Consider
#'   aggregating (e.g., `dplyr::summarise()`) to one row per (group, time)
#'   before calling `mutate_cagrs()`.
#' - **Gap detection**: A light-weight heuristic flags irregular spacing only
#'   when `time_var` is numeric/integer or date/datetime. For other types,
#'   gap detection is skipped.
#'
#' **Computation**
#'
#' Each requested period `n` produces a column named via the `names` pattern
#' (default: `"{.col}_{.fn}"`, where `{.fn}` is `"cagr_<n>"`). CAGRs are computed as
#' \deqn{\left(\frac{x_t}{x_{t-n}}\right)^{1/n} - 1}
#' using a safe implementation that returns `NA_real_` when either value is
#' missing or when the lagged base is non-positive.
#'
#' **Caveats**
#'
#' - **Multiple rows per (group, time)**: Aggregation to a single row per
#'   period is recommended before computing CAGRs. Duplicate (group, time)
#'   rows trigger a warning.
#' - **Zeros and negatives**: If the lagged base is `<= 0`, the corresponding
#'   CAGR is `NA_real_`. Consider an offset (domain-specific) or filtering
#'   non-positive values if appropriate.
#' - **Gaps in time**: CAGR assumes consistent period length. If gaps are
#'   present, values still compute (based on lag distance), but interpretation
#'   should be made with caution.
#' - **Time variable**: This function assumes `time_var` is already a well-behaved,
#'   sortable representation of time. If it is not (e.g., factor or
#'   arbitrary character labels), convert it upstream (e.g., to numeric year,
#'   `Date`) for correct results.
#' - **Performance**: For large grouped data, consider pre-aggregating and
#'   minimizing the number of requested `periods`.
#'
#' @param data A data frame.
#' @param values <[`data-masked`][dplyr::dplyr_data_masking]> column containing the numeric values on which
#'   CAGRs will be computed.
#' @param time_var <[`data-masked`][dplyr::dplyr_data_masking]> Unquoted column
#'   name indicating the time ordering used to pair values and their lags.
#'   It should be sortable in chronological order when used in
#'   `dplyr::arrange()`.
#' @param group_vars <[`tidy-select`][dplyr::dplyr_tidy_select]> Optional
#'   **tidyselect expression** evaluated in `data`
#'   that selects grouping columns, e.g. `c(region, brand)`,
#'   `dplyr::starts_with("geo_")`, or `NULL` for no grouping. Internally,
#'   this is resolved to concrete column names via `passed_colnames()`.
#' @param periods Integer vector of lag distances (period lengths) for which to
#'   compute CAGRs. Defaults to `c(2, 3, 4)`.
#' @param names A glue-style naming pattern for output columns. Defaults to
#'   `"{.col}_{.fn}"`. The function names are of the form `"cagr_<n>"`.
#' @param validate Logical; if `TRUE`, performs diagnostics (duplicates and,
#'   when feasible, gaps).
#' @param quiet Logical; if `TRUE`, suppresses `cli` warnings/messages.
#'

#' @return A data frame (a tibble if `data` is a tibble) with CAGR columns added
#'   (one per requested period.

#'
#' @section Recommended Workflow:
#' 1. Ensure at most one row per (group, time). If not, aggregate with
#'    `dplyr::summarise()` before computing CAGRs.
#' 2. Provide a well-behaved, sortable `time_var` (e.g., numeric year, `Date`).
#' 3. Inspect `cli` warnings for duplicates or (when applicable) gaps; address
#'    upstream as needed.
#' 4. Compute CAGRs with one call to `mutate_cagrs()` and use the resulting
#'    columns for plotting, dashboards, or further analysis.
#'
#' @examples
#' # --- Basic yearly CAGR by region ---
#' df <- tibble::tibble(
#'   region = rep(c("APAC", "EMEA"), each = 5),
#'   year = rep(2018:2022, times = 2),
#'   items = c(
#'     100, 110, 121, 133, 146,
#'     90, 95, 104, 115, 120
#'   )
#' )
#'
#' df_cagr <- mutate_cagrs(
#'   data       = df,
#'   values     = items,
#'   time_var   = year,
#'   group_vars = c(region),
#'   periods    = c(2, 4)
#' )
#'
#'
#' # --- Weekly date (well-behaved as Date) ---
#' df_wk <- tibble::tibble(
#'   week   = as.Date(c("2026-03-09", "2026-03-16", "2026-03-23", "2026-03-30")),
#'   items  = c(100, 105, 102, 108)
#' )
#' df_wk_cagr <- mutate_cagrs(
#'   data      = df_wk,
#'   values    = items,
#'   time_var  = week
#' )
#'
#' @seealso
#'   `calculate_cagr_safe()` for the underlying safe CAGR calculation;
#'   `dplyr::group_by()`, `dplyr::arrange()`, `dplyr::across()` for related tidyverse ops;
#'   `passed_colnames()` for resolving tidyselect expressions to names.
#' @export
mutate_cagrs <- function(
  data,
  values,
  time_var,
  group_vars = NULL,
  periods = c(2:4),
  names = "{.col}_{.fn}",
  validate = TRUE,
  quiet = FALSE,
  # optional knobs if you want to expose tolerance control
  gap_rel_tol_date = 0.10,
  gap_min_abs_tol_date = 1,
  gap_rel_tol_numeric = 0.00,
  gap_min_abs_tol_numeric = 0
) {
  # Resolve grouping columns
  group_quo <- rlang::enquo(group_vars)
  group_cols <- if (rlang::quo_is_null(group_quo)) character(0) else passed_colnames(data, group_quo)

  # Optional grouping
  if (length(group_cols) > 0) {
    data <- dplyr::group_by(data, dplyr::across(dplyr::all_of(group_cols)))
  }

  # Diagnostics
  if (validate) {
    # duplicates per (group, time)
    if (.check_duplicates_plain(data, group_cols, rlang::as_name(rlang::ensym(time_var))) && !quiet) {
      cli::cli_warn("Detected duplicate (group, time) rows; CAGR may be ambiguous. Consider aggregating first.")
    }

    # gap detection (NA means unsupported type)
    time_vec <- dplyr::pull(data, {{ time_var }})
    gaps_flag <- .detect_gaps(
      time_vec,
      rel_tol_date        = gap_rel_tol_date,
      min_abs_tol_date    = gap_min_abs_tol_date,
      rel_tol_numeric     = gap_rel_tol_numeric,
      min_abs_tol_numeric = gap_min_abs_tol_numeric
    )

    if (isTRUE(gaps_flag) && !quiet) {
      cli::cli_warn("Detected gaps in the time sequence; CAGRs assume consistent period spacing.")
    } else if (is.na(gaps_flag) && !quiet) {
      time_var_name <- rlang::as_name(rlang::ensym(time_var))
      time_var_type <- class(time_vec)[1]
      cli::cli_warn(
        c(
          "Gap detection skipped: ",
          "i" = "{.var {time_var_name}} is of type {time_var_type}, which is unsupported for gap diagnostics.",
          "!" = "Ensure {.var {time_var_name}} sorts chronologically and contains no gaps or else CAGRs may be incorrect"
        )
      )
    }
  }

  # Build functions for across()
  fns <- rlang::set_names(
    lapply(periods, function(n) function(x) calculate_cagr_safe(x, n)),
    paste0("cagr_", periods)
  )

  # Arrange and compute
  out <- data |>
    dplyr::arrange(
      dplyr::across(dplyr::all_of(group_cols)),
      {{ time_var }}
    ) |>
    dplyr::mutate(
      dplyr::across(
        .cols  = {{ values }},
        .fns   = fns,
        .names = names
      )
    ) |>
    dplyr::ungroup()

  out
}
