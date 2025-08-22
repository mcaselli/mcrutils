test_that("ytd_bounds() rolls back partial months", {
  expect_equal(
    ytd_bounds(
      c(ymd("2023-02-02"),
        ymd("2024-05-04"),
        ymd("2023-01-01")),
      rollback_partial_month = TRUE
    ),
    c(ymd("2024-01-01"), ymd("2024-04-30")
    )
  )
})

test_that("ytd_bounds() doesn't roll back a complete month, even when rollback_partial_month=TRUE", {
  expect_equal(
    ytd_bounds(
      c(ymd("2023-02-02"),
        ymd("2024-05-31"),
        ymd("2023-01-01")),
      rollback_partial_month = TRUE
    ),
    c(ymd("2024-01-01"), ymd("2024-05-31")
    )
  )
})

test_that("ytd_bounds() doesn't roll back a partial month, when rollback_partial_month=FALSE", {
  expect_equal(
    ytd_bounds(
      c(ymd("2023-02-02"),
        ymd("2024-05-30"),
        ymd("2023-01-01"))
    ),
    c(ymd("2024-01-01"), ymd("2024-05-30")
    )
  )
})

test_that("ytd_bounds() works with a single date", {
  expect_equal(
    ytd_bounds(ymd("2024-05-04")),
    c(ymd("2024-01-01"), ymd("2024-05-04"))
  )
})

test_that("ytd_bounds() works with datetimes", {
  expect_equal(
    ytd_bounds(
      c(lubridate::ymd_hms("2023-01-04 01:34:56"),
        lubridate::ymd_hms("2024-05-04 12:34:56"))
    ),
    c(ymd("2024-01-01"), ymd("2024-05-04"))
  )
})

test_that("ytd_bounds() works with ymd characters", {
  expect_equal(
    ytd_bounds(
      c("2023-01-01", "2024-05-04", "2023-02-02")
    ),
    c(ymd("2024-01-01"), ymd("2024-05-04"))
  )
})
