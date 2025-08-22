#' Find columns containing logical values stored as character or factor
#'
#' @param data A data frame or tibble
#'
#' @return A character vector of column names found to hold exclusively
#' logical data (or NA) that are typed as character or factor.
#'
#' @details
#' Columns are deemed to hold logical data if they contain only the values
#' c("T", "TRUE", "True", "true", "F", "FALSE", "False", "false", NA).
#' (matching [base::as.logical()])
#' @export
detect_hidden_logicals <- function(data) {
  # detect columns that are factors with levels (TRUE and FALSE)
  logical_levels <- c(
    "T", "TRUE", "True", "true",
    "F", "FALSE", "False", "false", NA
  )

  bool_as_char_cols <-
    sapply(
      data,
      function(x) is.character(x) && all(unique(x) %in% logical_levels)
    ) |>
    which() |>
    names()

  bool_as_factor_cols <-
    sapply(
      data,
      function(x) is.factor(x) && all(levels(x) %in% logical_levels)
    ) |>
    which() |>
    names()

  return(c(bool_as_char_cols, bool_as_factor_cols))
}


#' Normalize character or factor columns containing logical data to logical type
#'
#' @param data A data frame or tibble
#' @param quiet If `TRUE`, suppresses messages about the columns being converted
#'
#' @return A data frame or tibble with the specified columns converted to logical type
#'
#' @details
#' uses [detect_hidden_logicals()] to find columns that are character or
#' factor but contain logical values. Converts these columns to logical
#' type using [base::as.logical()].
#' @export
normalize_logicals <- function(data, quiet = FALSE) {
  hidden_logicals <- detect_hidden_logicals(data)

  if (length(hidden_logicals) == 0) {
    if (!quiet) {
      cli_inform("No character or factor columns detected containing logical data")
    }
    return(data)
  }

  data <- data |>
    mutate(across(
      all_of(hidden_logicals), as.logical
    ))
  if (!quiet) {
    cli_inform(
      "Converted {.val {hidden_logicals}} column{?s} to logical."
    )
  }
  return(data)
}
