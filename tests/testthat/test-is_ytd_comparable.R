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
  expect_equal(is_ytd_comparable(
    c("2023-05-06", "2023-02-01", "2023-04-01"),
    c("2024-05-05", "2024-02-01", "2024-04-15")),
    c(FALSE, TRUE, TRUE))
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
    is_ytd_comparable(lubridate::ymd_hms("2024-02-29 12:00:00"),
                      lubridate::ymd_hms("2025-02-28 23:59:59")),
    FALSE)
})
