check_valid_single_calendar <- function(calendar) {
  if (!is.character(calendar) || length(calendar) != 1) {
    cli::cli_abort(c(
      "{.arg calendar} must be a single character string with the id of a QuantLib calendar.",
      "x" = "You provided an object of class {.cls {class(calendar)}} with length {length(calendar)}.",
      "i" = "See {.code qlcal::calendars} for valid options."
    ))
  }
  if (!(calendar %in% qlcal::calendars)) {
    cli::cli_abort(c(
      "{.arg calendar} must be a valid QuantLib calendar id.",
      "x" = "{.val {calendar}} is not a recognized QuantLib calendar id.",
      "i" = "See {.code qlcal::calendars} for valid options."
    ))
  }
}
