test_that("we can calculate prior year for a single date", {
  expect_equal(
    py_dates(lubridate::ymd("2024-05-04")),
    lubridate::ymd("2023-05-04")
  )
})

test_that("we can calculate prior year for a vector of dates", {
  expect_equal(
    py_dates(lubridate::ymd(c("2024-05-04", "2024-01-01"))),
    lubridate::ymd(c("2023-05-04", "2023-01-01"))
  )
})

test_that("we can calculate prior year for a vector of dates with NA", {
  expect_equal(
    py_dates(lubridate::ymd(c("2024-05-04", NA, "2024-01-01"))),
    lubridate::ymd(c("2023-05-04", NA, "2023-01-01"))
  )
})

test_that("we can calculate prior year for a vector of dates with leap day", {
  expect_equal(
    py_dates(lubridate::ymd(c("2024-02-29", "2024-03-01"))),
    lubridate::ymd(c("2023-02-28", "2023-03-01"))
  )
})

test_that("we can calculate prior year for a datetime", {
  expect_equal(
    py_dates(lubridate::ymd_hms("2024-05-04 12:34:56")),
    lubridate::ymd_hms("2023-05-04 12:34:56")
  )
})
