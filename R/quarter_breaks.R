#' Generate quarterly, semester, or year breaks for dates
#'
#' This function generates breaks for quarterly, semester, or yearly intervals,
#' either in fixed-width mode or automatic mode.
#'
#' @param n The number of breaks to generate in automatic mode.
#' @param width The fixed width of breaks in fixed-width mode.
#'  Should be a specification of the form `"n unit"`,
#'  where `n` is a number and `unit` is one of "month", "quarter", or "year"
#'  (optionally plural).
#'  For example, "3 months", "1 quarter", or "2 years".
#'  If unit is months, value must be 3, 6 or 12 (so you get quarters).
#'  If unit is quarters, value must be 1, 2, or 4
#'  (so you get quarters, semesters, or years).
#'  If unit is years, value must be 1.
#'
#'  @note
#'  This function will never create breaks longer than one year.
#'  If that's desired, you're probably better off sticking with the standard
#'  ggplot approach
#'  `scale_x_date(date_breaks = "5 years", date_labels = "%y")`.
#'
#' @return A function that takes a vector of dates and returns a vector of dates
#' for use as breaks
#'
#' @export
breaks_quarters <- function(n = 9, width = NULL) {
  function(x) {
    x <- as.Date(x)
    rng <- range(x, na.rm = TRUE)

    q_start <- function(date) {
      lubridate::quarter(date, type = "date_first")
    }

    start <- q_start(rng[1])
    end <- rng[2]

    if (!is.null(width)) {
      if (length(width) != 1L) {
        stop("width must be length 1")
      }
      if (!is.character(width)) stop("width must be a character string")
      parsed_width <- stringr::str_match(width, pattern = "^([0-9]+) (month|quarter|year)s?$")
      mag <- as.numeric(parsed_width[2])
      unit <- parsed_width[3]
      if (is.na(mag) || is.na(unit)) {
        stop("width must be of the form 'n unit', where n is a number and unit is one of 'month', 'quarter', or 'year' (optionally plural)")
      }

      if (unit == "month") {
        if (mag == 3) {
          return(calc_quarter_breaks(x))
        } else if (mag == 6) {
          return(calc_semester_breaks(x))
        } else if (mag == 12) {
          return(calc_year_breaks(x))
        } else {
          stop("Invalid width for breaks_quarters. If unit is months, value must be 3, 6 or 12")
        }
      } else if (unit == "quarter") {
        if (mag == 1) {
          return(calc_quarter_breaks(x))
        } else if (mag == 2) {
          return(calc_semester_breaks(x))
        } else if (mag == 4) {
          return(calc_year_breaks(x))
        } else {
          stop("Invalid width for breaks_quarters. If unit is quarters, value must be 1, 2, or 4")
        }
      } else if (unit == "year") {
        if (mag == 1) {
          return(calc_year_breaks(x))
        } else {
          stop("Invalid width for breaks_quarters. If unit is years, value must be 1")
        }
      }
    }

    # Automatic mode: choose between quarter, semester, or year breaks to
    # achieve approximately `n` breaks
    all_qs <- seq(from = start, to = q_start(end), by = "3 months")
    len <- length(all_qs)

    len_err <- len - n
    tol <- n / 4
    if (len_err > tol) {
      year_span <- diff(rng) / lubridate::dyears()
      if (year_span * 2 <= n + tol) {
        return(calc_semester_breaks(x))
      } else {
        return(calc_year_breaks(x))
      }
    }

    all_qs
  }
}

#' Calculate quarterly breaks for dates
#'
#' This function calculates quarterly breaks for a given range of dates.
#'
#' @details
#' These breaks are floor dates for the quarter, so
#' `min(dates) >= min(calc_quarter_breaks(dates))`
#' and `max(dates) <= max(calc_quarter_breaks(dates))`.
#'
#' @param dates A vector of dates, or something coercible with
#'   [base::as.Date]
#'
#' @return A vector of dates representing the start of each quarter
#' within the range of `dates`.
calc_quarter_breaks <- function(dates) {
  dates <- as.Date(dates)
  rng <- range(dates, na.rm = TRUE)
  start <- lubridate::quarter(rng[1], type = "date_first")
  end <- rng[2]
  seq(from = start, to = end, by = "3 months")
}


#' Calculate semester breaks for dates
#'
#' This function calculates semester breaks for a given range of dates.
#'
#' @details
#' These breaks are floor dates for the semester, so
#' `min(dates) >= min(calc_semester_breaks(dates))`
#' and `max(dates) <= max(calc_quarter_breaks(dates))`.
#'
#' @param dates A vector of dates, or something coercible with
#'   [base::as.Date]
#'
#' @return A vector of dates representing the start of each semester
#' within the range of `dates`.
calc_semester_breaks <- function(dates) {
  dates <- as.Date(dates)
  rng <- range(dates, na.rm = TRUE)
  start <- lubridate::quarter(rng[1], type = "date_first")
  end <- rng[2]

  if (!lubridate::quarter(start) %in% c(1, 3)) {
    # roll start back to a semester start date
    start <- start - months(3)
  }

  seq(from = start, to = end, by = "6 months")
}

#' Calculate yearly breaks for dates
#'
#' This function calculates yearly breaks for a given range of dates.
#'
#' @details
#' These breaks are floor dates for the year, so
#' `min(dates) >= min(calc_year_breaks(dates))`
#' and `max(dates) <= max(calc_yearr_breaks(dates))`.
#'
#' @param dates A vector of dates, or something coercible with
#'   [base::as.Date]
#'
#' @return A vector of dates representing the start of each year
#' within the range of `dates`.
calc_year_breaks <- function(dates) {
  dates <- as.Date(dates)
  rng <- range(dates, na.rm = TRUE)

  start <- lubridate::floor_date(rng[1], unit = "year")
  end <- rng[2]
  seq(from = start, to = end, by = "1 year")
}


#' Generate labels for quarters with year
#'
#' This function generates labels for quarters in a short format,
#' showing the quarter and year only when it changes from the previous label,
#' similar to [scales::label_date_short()].
#'
#' This should generally be used in conjunction with breaks that are
#' the dates of the start of a quarter, e.g. as from
#' [breaks_quarters()].
#'
#' @return A function that takes a vector of dates and returns labels in
#' the format "Qx\\nYYYY" or "Qn"
#' @export
label_quarters_short <- function() {
  function(dates) {
    # needs to be robust to NA dates, as those are sometimes introduced by
    # ggplot's scale expansion
    dates <- as.Date(dates)
    years <- format(dates, "%Y")
    quarters <- paste0("Q", lubridate::quarter(dates, type = "quarter"))
    quarters[which(is.na(dates))] <- NA # preserve NA dates

    # Show year only when it changes from the previous label
    # Only compare adjacent non-NA years
    show_year <- rep(NA, length(dates))
    non_na_idx <- which(!is.na(years))

    if (length(non_na_idx) > 0) {
      show_year[non_na_idx] <- c(
        TRUE,
        years[non_na_idx][-1] != years[non_na_idx][-length(non_na_idx)]
      )
    }

    # Combine labels, preserving NA
    labels <- ifelse(is.na(dates), NA,
      ifelse(
        show_year,
        paste(quarters, years, sep = "\n"),
        quarters
      )
    )

    labels
  }
}
