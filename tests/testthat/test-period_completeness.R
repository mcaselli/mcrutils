# period_start_date() / period_end_date() ------------------------------------

test_that("period boundaries return canonical calendar dates", {
  expect_equal(period_start_date(as.Date("2025-05-14"), "month"), as.Date("2025-05-01"))
  expect_equal(period_end_date(as.Date("2025-05-14"), "month"), as.Date("2025-05-31"))
  expect_equal(period_start_date(as.Date("2025-05-14"), "quarter"), as.Date("2025-04-01"))
  expect_equal(period_end_date(as.Date("2025-05-14"), "quarter"), as.Date("2025-06-30"))
  expect_equal(period_start_date(as.Date("2025-05-14"), "year"), as.Date("2025-01-01"))
  expect_equal(period_end_date(as.Date("2025-05-14"), "year"), as.Date("2025-12-31"))
})

test_that("period_end_date() is correct on a period-boundary date", {
  # 2025-01-01 is a month boundary; its period end is still 2025-01-31
  expect_equal(period_end_date(as.Date("2025-01-01"), "month"), as.Date("2025-01-31"))
})

test_that("period boundaries handle leap February and coerce strings", {
  expect_equal(period_end_date("2024-02-10", "month"), as.Date("2024-02-29"))
  expect_equal(period_end_date("2025-02-10", "month"), as.Date("2025-02-28"))
})

test_that("period boundaries are vectorized and return Date", {
  out <- period_end_date(as.Date(c("2025-01-15", "2025-02-15")), "month")
  expect_s3_class(out, "Date")
  expect_equal(out, as.Date(c("2025-01-31", "2025-02-28")))
})

test_that("week boundaries respect week_start", {
  # 2025-07-03 is a Thursday
  expect_equal(
    period_start_date(as.Date("2025-07-03"), "week", week_start = 1), # Monday
    as.Date("2025-06-30")
  )
  expect_equal(
    period_start_date(as.Date("2025-07-03"), "week", week_start = 7), # Sunday
    as.Date("2025-06-29")
  )
})

# period_is_complete() -------------------------------------------------------

test_that("period_is_complete() is TRUE when as_of is on the period end", {
  expect_true(period_is_complete(as.Date("2025-05-15"), "month", as.Date("2025-05-31")))
})

test_that("a month ending on a weekend is complete after its last business day", {
  # May 2025 ends Saturday the 31st; the last business day is Friday the 30th
  expect_true(period_is_complete(as.Date("2025-05-15"), "month", as.Date("2025-05-30")))
  expect_false(period_is_complete(as.Date("2025-05-15"), "month", as.Date("2025-05-29")))
})

test_that("calendar = 'Null' reduces to pure calendar-day completeness", {
  # May is not complete until every calendar day has elapsed
  expect_false(
    period_is_complete(as.Date("2025-05-15"), "month", as.Date("2025-05-30"), calendar = "Null")
  )
  expect_true(
    period_is_complete(as.Date("2025-05-15"), "month", as.Date("2025-05-31"), calendar = "Null")
  )

  # equivalence to period_end_date(date) <= as_of across a date sweep
  set.seed(1)
  dates <- as.Date("2025-01-01") + sample(0:400, 60)
  as_of <- as.Date("2025-06-10")
  expect_equal(
    period_is_complete(dates, "month", as_of, calendar = "Null"),
    period_end_date(dates, "month") <= as_of
  )
})

test_that("period_is_complete() is vectorized correctly over a span of periods", {
  # Regression guard: as_of (2025-05-30) is the last business day of its own
  # month, yet a future month must still read incomplete. A naive implementation
  # that tests as_of's own period instead of each date's period would wrongly
  # mark future periods complete here.
  expect_equal(
    period_is_complete(
      as.Date(c("2025-04-15", "2025-05-15", "2025-06-15")),
      "month",
      as_of = as.Date("2025-05-30")
    ),
    c(TRUE, TRUE, FALSE)
  )
})

test_that("a holiday calendar completes a period earlier than weekends-only", {
  # Week of 2025-06-30..2025-07-06 (Monday start); Fri 2025-07-04 is a US holiday.
  # As of Thursday 2025-07-03 only Fri (holiday) + weekend remain.
  thu <- as.Date("2025-07-03")
  expect_true(
    period_is_complete(thu, "week", thu, calendar = "UnitedStates", week_start = 1)
  )
  expect_false(
    period_is_complete(thu, "week", thu, calendar = "WeekendsOnly", week_start = 1)
  )
})

test_that("period_is_complete() errors on a length-mismatched as_of", {
  expect_error(
    period_is_complete(
      as.Date(c("2025-01-15", "2025-02-15", "2025-03-15")),
      "month",
      as_of = as.Date(c("2025-01-01", "2025-02-01"))
    ),
    "length 1 or the same length"
  )
})

test_that("period_is_complete() errors on an invalid unit", {
  expect_error(
    period_is_complete(as.Date("2025-05-15"), unit = "fortnight"),
    class = "rlang_error"
  )
})

# filter_complete_periods() --------------------------------------------------

test_that("filter_complete_periods() drops a partial trailing month (common case)", {
  # The common case: a daily series that runs only partway into the latest
  # month. April and May are fully elapsed, but June is populated only through
  # the 12th, so the whole partial month is judged incomplete and dropped.
  # as_of defaults to max(day) = 2025-06-12.
  df <- data.frame(day = seq(as.Date("2025-04-01"), as.Date("2025-06-12"), by = "day"))
  out <- filter_complete_periods(df, day, unit = "month")

  expect_equal(nrow(out), 61L) # all of April (30) + May (31)
  expect_equal(min(out$day), as.Date("2025-04-01"))
  expect_equal(max(out$day), as.Date("2025-05-31"))
  expect_true(all(out$day < as.Date("2025-06-01"))) # no partial-June rows survive
})

test_that("filter_complete_periods() honours an as_of later than the data max", {
  # Assert the data is current through 2025-06-30 even though its last row is the
  # 12th; the (data-partial) June then counts as a complete period and is kept.
  df <- data.frame(day = seq(as.Date("2025-04-01"), as.Date("2025-06-12"), by = "day"))
  out <- filter_complete_periods(df, day, unit = "month", as_of = as.Date("2025-06-30"))

  expect_equal(nrow(out), 73L) # April (30) + May (31) + partial June (12)
  expect_true(any(out$day >= as.Date("2025-06-01")))
})

test_that("filter_complete_periods() completes a trailing period when as_of is in the next period", {
  # Data collection for June is done (last row 2026-06-28, a Sunday) and we are
  # now in July. With as_of in the next period, June is a complete period and is
  # kept in full -- even though its final Mon/Tue (29th, 30th) carry no rows.
  df <- data.frame(day = seq(as.Date("2026-05-01"), as.Date("2026-06-28"), by = "day"))

  kept <- filter_complete_periods(df, day, unit = "month", as_of = as.Date("2026-07-02"))
  expect_equal(nrow(kept), 59L) # all of May (31) + June 1-28 (28)
  expect_equal(max(kept$day), as.Date("2026-06-28"))

  # Contrast: with the default as_of = max(day) = 2026-06-28, June still has two
  # business days remaining (Mon 29th, Tue 30th), so the June rows are dropped.
  default_kept <- filter_complete_periods(df, day, unit = "month")
  expect_equal(nrow(default_kept), 31L) # May only
  expect_true(all(default_kept$day < as.Date("2026-06-01")))
})

test_that("filter_complete_periods() rejects an as_of earlier than the data max", {
  # An as_of before the data's max would drop periods the data demonstrably
  # completes, so it is an error.
  df <- data.frame(day = seq(as.Date("2025-04-01"), as.Date("2025-06-12"), by = "day"))
  expect_error(
    filter_complete_periods(df, day, unit = "month", as_of = as.Date("2025-05-15")),
    "earlier than the maximum"
  )
})

# last_complete_period_end() / last_complete_period_start() -------------------

test_that("last_complete_period_end() steps back over an in-progress period", {
  # 2025-05-30 is in Q2 2025, still in progress -> last complete quarter is Q1
  end <- last_complete_period_end(as.Date("2025-05-30"), "quarter")
  expect_s3_class(end, "Date")
  expect_equal(end, as.Date("2025-03-31"))
  expect_equal(
    last_complete_period_start(as.Date("2025-05-30"), "quarter"),
    as.Date("2025-01-01")
  )
})

test_that("last_complete_period_end() returns the current period end when it is complete", {
  # As of 2025-03-31 (a Monday, the last day of Q1), Q1 is complete
  expect_equal(
    last_complete_period_end(as.Date("2025-03-31"), "quarter"),
    as.Date("2025-03-31")
  )
})

test_that("last_complete_period_end() is vectorized over as_of", {
  out <- last_complete_period_end(
    as.Date(c("2025-05-30", "2025-08-15")),
    "quarter"
  )
  expect_equal(out, as.Date(c("2025-03-31", "2025-06-30")))
})

# scale_alpha_logical() ------------------------------------------------------

test_that("scale_alpha_logical() returns a ggplot2 scale", {
  expect_s3_class(scale_alpha_logical(), "Scale")
})

test_that("scale_alpha_logical() maps FALSE/TRUE to the supplied alpha levels", {
  p <- ggplot2::ggplot(
    data.frame(x = 1:2, done = c(FALSE, TRUE)),
    ggplot2::aes(x, x, alpha = done)
  ) +
    ggplot2::geom_point() +
    scale_alpha_logical(false_alpha = 0.2, true_alpha = 0.9)
  built <- ggplot2::ggplot_build(p)$data[[1]]
  expect_setequal(built$alpha, c(0.2, 0.9))
})

# NA handling ----------------------------------------------------------------

test_that("period_is_complete() returns NA for NA dates", {
  expect_equal(
    period_is_complete(
      as.Date(c("2025-04-15", NA, "2025-06-15")),
      "month",
      as_of = as.Date("2025-06-30")
    ),
    c(TRUE, NA, TRUE)
  )
})

test_that("filter_complete_periods() drops NA-date rows without error", {
  # default as_of = max(day, na.rm) = 2025-06-15: April complete, NA dropped,
  # June still in progress
  df <- data.frame(day = as.Date(c("2025-04-15", NA, "2025-06-15")))
  out <- filter_complete_periods(df, day, unit = "month")
  expect_equal(out$day, as.Date("2025-04-15"))
})

test_that("filter_complete_periods() returns no rows for an all-NA date column", {
  df <- data.frame(day = as.Date(c(NA, NA)))
  expect_no_warning(out <- filter_complete_periods(df, day, unit = "month"))
  expect_equal(nrow(out), 0L)
})

# additional argument / unit coverage ----------------------------------------

test_that("period_is_complete() accepts a vector as_of matching date", {
  expect_equal(
    period_is_complete(
      as.Date(c("2025-01-15", "2025-02-15", "2025-06-15")),
      "month",
      as_of = as.Date(c("2025-01-31", "2025-02-15", "2025-06-30"))
    ),
    c(TRUE, FALSE, TRUE)
  )
})

test_that("period_end_date() respects week_start", {
  # 2025-07-03 is a Thursday
  expect_equal(period_end_date("2025-07-03", "week", week_start = 1), as.Date("2025-07-06")) # Sun
  expect_equal(period_end_date("2025-07-03", "week", week_start = 7), as.Date("2025-07-05")) # Sat
})

test_that("period_is_complete() handles the year unit", {
  # year: 2024-12-31 is a business day (Tuesday), so the year is not complete
  # until it elapses
  expect_false(period_is_complete(as.Date("2024-06-15"), "year", as.Date("2024-12-30")))
  expect_true(period_is_complete(as.Date("2024-06-15"), "year", as.Date("2024-12-31")))
})

test_that("the period family rejects units outside week/month/quarter/year", {
  # "day" is intentionally not a valid period unit for completeness reasoning
  expect_error(period_start_date(as.Date("2025-05-15"), "day"), class = "rlang_error")
  expect_error(period_end_date(as.Date("2025-05-15"), "day"), class = "rlang_error")
  expect_error(period_is_complete(as.Date("2025-05-15"), unit = "day"), class = "rlang_error")
  expect_error(period_start_date(as.Date("2025-05-15"), "fortnight"), class = "rlang_error")
  expect_error(period_end_date(as.Date("2025-05-15"), "fortnight"), class = "rlang_error")
})

test_that("filter_complete_periods() errors on a length > 1 as_of", {
  df <- data.frame(day = as.Date(c("2025-04-15", "2025-05-15")))
  expect_error(
    filter_complete_periods(
      df, day,
      unit = "month",
      as_of = as.Date(c("2025-05-31", "2025-06-30"))
    ),
    "single date"
  )
})

test_that("last_complete_period_*() work for the default month unit", {
  # 2025-05-15 is mid-May, so the last complete month is April
  expect_equal(last_complete_period_end(as.Date("2025-05-15")), as.Date("2025-04-30"))
  expect_equal(last_complete_period_start(as.Date("2025-05-15")), as.Date("2025-04-01"))
})

# internal helper ------------------------------------------------------------

test_that("n_bizdays_remaining() recycles both directions and propagates NA", {
  expect_equal(
    n_bizdays_remaining(as.Date("2025-06-02"), as.Date(c("2025-06-02", "2025-06-03")), "Null"),
    c(0L, 1L)
  )
  expect_equal(
    n_bizdays_remaining(as.Date(c("2025-06-02", "2025-06-03")), as.Date("2025-06-03"), "Null"),
    c(1L, 0L)
  )
  expect_equal(
    n_bizdays_remaining(as.Date(c("2025-06-02", NA)), as.Date("2025-06-10"), "Null"),
    c(8L, NA_integer_)
  )
})
