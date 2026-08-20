test_that("is_ytd_comparable() works with a single value before the end date", {
  expect_equal(is_ytd_comparable("2023-05-04", "2024-05-31"), TRUE)
})


test_that("is_ytd_comparable() works with a single value after the end date", {
  expect_equal(is_ytd_comparable("2023-05-04", "2024-02-01"), FALSE)
})

test_that("is_ytd_comparable() works with a single value on the end date", {
  expect_equal(is_ytd_comparable("2023-05-04", "2024-05-04"), TRUE)
})

test_that("is_ytd_comparable() works with a vector of dates and one end date", {
  expect_equal(is_ytd_comparable(c("2023-05-04", "2023-05-06"), "2025-05-04"), c(TRUE, FALSE))
})


test_that("is_ytd_comparable() works with a vector of dates and equal length vector of end_date ", {
  expect_equal(
    is_ytd_comparable(
      c("2023-05-06", "2023-02-01", "2023-04-01"),
      c("2024-05-05", "2024-02-01", "2024-04-15")
    ),
    c(FALSE, TRUE, TRUE)
  )
})

test_that("is_ytd_comparable() works with NA values", {
  expect_equal(is_ytd_comparable(c("2023-05-04", NA), "2024-05-31"), c(TRUE, NA))
})

test_that("is_ytd_comparable() works with leap day as end_date", {
  expect_equal(is_ytd_comparable("2023-02-28", "2024-02-29"), TRUE)
})

test_that("is_ytd_comparable() works with leap day as date", {
  expect_equal(is_ytd_comparable("2024-02-29", "2025-02-28"), FALSE)
})

test_that("is_ytd_comparable() works with datetimes", {
  expect_equal(
    is_ytd_comparable(
      lubridate::ymd_hms("2024-02-29 12:00:00"),
      lubridate::ymd_hms("2025-02-28 23:59:59")
    ),
    FALSE
  )
})

test_that("is_ytd_comparable() ignores the time component on the boundary day", {
  # The documented contract is that datetimes are coerced to dates and the time
  # component ignored. Only `end_date` was coerced, so a POSIXct `date` was
  # compared against a Date promoted to midnight - and every timestamp later
  # than 00:00:00 on the boundary day failed, silently dropping the final day
  # of the window.
  expect_true(is_ytd_comparable(
    lubridate::ymd_hms("2026-07-31 09:00:00"),
    as.Date("2026-07-31")
  ))
  expect_true(is_ytd_comparable(
    lubridate::ymd_hms("2026-07-31 23:59:59"),
    as.Date("2026-07-31")
  ))
  # the day after is still excluded
  expect_false(is_ytd_comparable(
    lubridate::ymd_hms("2026-08-01 00:00:01"),
    as.Date("2026-07-31")
  ))
})

test_that("is_ytd_comparable() gives the same answer for a POSIXct and a Date column", {
  # A timestamped historical row on the comparable month-day must be retained,
  # so that a POSIXct column and a Date column yield the same YTD window.
  ts <- lubridate::ymd_hms(c("2024-07-31 14:20:00", "2025-07-31 08:00:00"))
  expect_equal(is_ytd_comparable(ts, as.Date("2026-07-31")), c(TRUE, TRUE))
  expect_equal(
    is_ytd_comparable(ts, as.Date("2026-07-31")),
    is_ytd_comparable(as.Date(ts), as.Date("2026-07-31"))
  )
})
