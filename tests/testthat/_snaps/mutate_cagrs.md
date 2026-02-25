# UI snapshot: unordered factor ordering warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year_fac, periods = 1,
        names = "{.fn}", validate = TRUE, quiet = FALSE))
    Condition
      Warning:
      Gap detection skipped:
      i `year_fac` is of type factor, which is unsupported for gap diagnostics.
      ! Ensure `year_fac` sorts chronologically and contains no gaps or else CAGRs may be incorrect

# UI snapshot: ordered factor ordering warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year_fac, periods = 1,
        names = "{.fn}", validate = TRUE, quiet = FALSE))
    Condition
      Warning:
      Gap detection skipped:
      i `year_fac` is of type ordered, which is unsupported for gap diagnostics.
      ! Ensure `year_fac` sorts chronologically and contains no gaps or else CAGRs may be incorrect

# UI snapshot: unknown character format uses lexicographic fallback

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = label, periods = 1,
        names = "{.fn}", validate = TRUE, quiet = FALSE))
    Condition
      Warning:
      Gap detection skipped:
      i `label` is of type character, which is unsupported for gap diagnostics.
      ! Ensure `label` sorts chronologically and contains no gaps or else CAGRs may be incorrect

# UI snapshot: duplicate (group, time) rows warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year, group_vars = c(
        region), periods = 1, names = "{.fn}", validate = TRUE, quiet = FALSE))
    Condition
      Warning:
      Detected duplicate (group, time) rows; CAGR may be ambiguous. Consider aggregating first.

# UI snapshot: gaps in time sequence warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year, periods = 1,
        names = "{.fn}", validate = TRUE, quiet = FALSE))
    Condition
      Warning:
      Detected gaps in the time sequence; CAGRs assume consistent period spacing.

