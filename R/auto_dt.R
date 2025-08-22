#' Guesses appropriate format class for each numeric column in a data frame
#'
#' Using column names, this function classifies numeric columns into
#' three classes: percentage, currency, and numeric. It uses the presence of
#' specific flags in the column names to determine the class of each column.
#' Numeric columns whose names don't contain any `pct_flags` or `curr_flags`
#' are classified as numeric.
#'
#' @param data a data frame
#' @param pct_flags a character vector of flags to identify percentage columns
#' @param curr_flags a character vector of flags to identify currency columns
#'
#'
#' @return a list with three character vectors: numeric, pct, currency,
#' with the names of the columns in each class
#' @export
guess_col_fmts <- function(data, pct_flags = c("frac", "pct", "percent"),
                           curr_flags = c("revenue", "asp", "cogs")) {
  numeric_cols <- data |>
    select(where(is.numeric)) |>
    colnames()

  pct_cols <- data |>
    select(where(is.numeric) & contains(pct_flags)) |>
    colnames()

  currency_cols <- data |>
    select(where(is.numeric) & contains(curr_flags)) |>
    colnames()

  # column should be in only one class, priority order: currency, pct, numeric
  numeric_cols <- setdiff(numeric_cols, c(pct_cols, currency_cols))
  pct_cols <- setdiff(pct_cols, currency_cols)
  currency_cols <- setdiff(currency_cols, numeric_cols)

  return(list(
    numeric = numeric_cols,
    pct = pct_cols,
    currency = currency_cols
  ))
}


#' creates a datatable with some automatic formatting
#'
#' This function creates a datatable with automatic formatting for percentage,
#' currency, and numeric columns, using [guess_col_fmts()] to determine which
#' columns are percentages, currency, or numeric.
#'
#' @param data a data frame to be displayed as a datatable
#' @param pct_digits number of digits to display for percentage columns
#' @param currency_digits number of digits to display for currency columns
#' @param numeric_digits number of digits to display for numeric columns
#' @param ... additional arguments passed to [guess_col_fmts()]
#'
#' @return a datatable with formatted columns, filter at top, and no rownames
#' @export
auto_dt <- function(data, pct_digits = 1, currency_digits = 0,
                    numeric_digits = 0, ...) {
  col_classes <- guess_col_fmts(data, ...)

  DT::datatable(data, rownames = FALSE, filter = "top") |>
    DT::formatPercentage(
      col_classes$pct,
      digits = pct_digits
    ) |>
    DT::formatCurrency(
      col_classes$currency,
      digits = currency_digits
    ) |>
    DT::formatRound(
      col_classes$numeric,
      digits = numeric_digits
    )
}
