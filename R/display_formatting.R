#' Rename columns for display
#'
#' Convert snake_case-like column names to title-style labels, optionally
#' preserving selected acronyms in uppercase.
#'
#' @param data A data frame or tibble.
#' @param all_caps A character vector of tokens to preserve in uppercase.
#'   Matching is case-insensitive and applied to whole words after formatting.
#'
#' @return A data frame with renamed columns.
#'
#' @examples
#' data.frame(volume_py = 1, abc_units = 2) |>
#'   rename_cols_for_display(all_caps = c("PY", "ABC"))
#' @export
rename_cols_for_display <- function(data, all_caps = character()) {
  if (!is.character(all_caps)) {
    cli::cli_abort(c(
      "{.arg all_caps} must be a character vector of acronyms to preserve in uppercase.",
      "x" = "You provided an object of class {.cls {class(all_caps)}}."
    ))
  }

  format_name <- function(x) {
    label <- x |>
      stringr::str_replace_all("[-._]+", " ") |>
      stringr::str_squish() |>
      stringr::str_to_title()

    if (length(all_caps) == 0) {
      return(label)
    }

    escaped_terms <- stringr::str_replace_all(
      all_caps,
      "([.|()\\^{}+$*?]|\\[|\\]|\\\\)",
      "\\\\\\1"
    )
    pattern <- paste0(
      "\\b(",
      paste(stringr::str_to_lower(escaped_terms), collapse = "|"),
      ")\\b"
    )

    stringr::str_replace_all(
      label,
      stringr::regex(pattern, ignore_case = TRUE),
      function(match) stringr::str_to_upper(match)
    )
  }

  data |>
    dplyr::rename_with(format_name)
}
