test_that(".detect_gaps: yearly Jan-01 dates do not flag gaps (leap-year tolerated)", {
  v <- as.Date(c("2020-01-01", "2021-01-01", "2022-01-01"))
  expect_false(.detect_gaps(v))
})

test_that(".detect_gaps: missing year in annual sequence flags a gap", {
  v <- as.Date(c("2020-01-01", "2022-01-01", "2023-01-01"))
  expect_true(.detect_gaps(v))
})

test_that(".detect_gaps: monthly first-of-month dates are not flagged", {
  v <- as.Date(c(
    "2026-01-01", "2026-02-01", "2026-03-01", "2026-04-01", "2026-05-01",
    "2026-06-01", "2026-07-01", "2026-08-01", "2026-09-01", "2026-10-01",
    "2026-11-01", "2026-12-01"
  ))
  expect_false(.detect_gaps(v))
})

test_that(".detect_gaps: missing a month in monthly sequence flags a gap", {
  v <- as.Date(c("2026-01-01", "2026-02-01", "2026-03-01", "2026-05-01", "2026-06-01")) # skipped April
  expect_true(.detect_gaps(v))
})

test_that(".detect_gaps: weekly steps ok, missing week flagged", {
  v_ok <- as.Date("2026-03-01") + c(0, 7, 14, 21, 28)
  v_gap <- as.Date("2026-03-01") + c(0, 7, 21, 28)
  expect_false(.detect_gaps(v_ok))
  expect_true(.detect_gaps(v_gap))
})

test_that(".detect_gaps: numeric strict by default", {
  v <- c(1, 2, 3, 7, 8)
  expect_true(.detect_gaps(v))
})

test_that(".detect_gaps: numeric equal steps ok", {
  v <- seq(0, 100, by = 10)
  expect_false(.detect_gaps(v))
})

test_that(".detect_gaps: duplicates and NAs are ignored", {
  v <- c(1, 1, 2, NA, 2, 3, 4, 4, 5) # unique sorted: 1..5
  expect_false(.detect_gaps(v))
})

test_that(".detect_gaps: unsupported types return NA", {
  expect_true(is.na(.detect_gaps(c("2020", "2021", "2022"))))
  expect_true(is.na(.detect_gaps(factor(c("2020", "2021", "2022")))))
})

test_that(".detect_gaps: POSIXct behaves like Date with tolerance", {
  v <- as.POSIXct(
    c(
      "2020-01-01 00:00:00",
      "2021-01-01 00:00:00",
      "2022-01-01 00:00:00"
    ),
    tz = "UTC"
  )
  expect_false(.detect_gaps(v))
})

test_that(".detect_gaps: configurable numeric tolerance works (optional)", {
  v <- c(0, 10, 19, 30) # diffs: 10, 9, 11 (common ~10)
  expect_false(.detect_gaps(v, rel_tol_numeric = 0.10, min_abs_tol_numeric = 0))
  expect_true(.detect_gaps(v, rel_tol_numeric = 0.00, min_abs_tol_numeric = 0))
})
