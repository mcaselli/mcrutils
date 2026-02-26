# UI snapshot: unordered factor ordering warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year_fac, periods = 1))
    Condition
      Warning:
      Gap detection skipped:
      i `year_fac` is of type factor, which is unsupported for gap diagnostics.
      ! Ensure `year_fac` sorts chronologically and contains no gaps, or else CAGRs may be incorrect.

# UI snapshot: ordered factor ordering warning

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = year_fac))
    Condition
      Warning:
      Gap detection skipped:
      i `year_fac` is of type ordered, which is unsupported for gap diagnostics.
      ! Ensure `year_fac` sorts chronologically and contains no gaps, or else CAGRs may be incorrect.

# UI snapshot: unknown character format uses lexicographic fallback

    Code
      invisible(mutate_cagrs(data = df, values = value, time_var = label, periods = 1))
    Condition
      Warning:
      Gap detection skipped:
      i `label` is of type character, which is unsupported for gap diagnostics.
      ! Ensure `label` sorts chronologically and contains no gaps, or else CAGRs may be incorrect.

# UI snapshot: duplicate (group, time) rows error

    Code
      mutate_cagrs(data = df, values = value, time_var = year, group_vars = region,
        periods = 1)
    Condition
      Error in `mutate_cagrs()`:
      ! Detected duplicate (group, time) rows; CAGR would be ambiguous. Consider aggregating first.

# UI snapshot: gaps in time sequence error

    Code
      mutate_cagrs(data = df, values = value, time_var = year, periods = 1, names = "{.fn}")
    Condition
      Error in `mutate_cagrs()`:
      ! Detected gaps in the time sequence; CAGRs assume consistent period spacing.

