test_that("calc_semester_breaks rolls back when needed", {
  expect_equal(
    calc_semester_breaks(ymd(c("2000-04-04", "2001-07-03"))),
    ymd(c(
      "2000-01-01", "2000-07-01",
      "2001-01-01", "2001-07-01"
    ))
  )
})

test_that("calc_semester_breaks works with a single date", {
  expect_equal(calc_semester_breaks(ymd("2025-09-04")), ymd("2025-07-01"))
})

test_that("calc_semester_breaks doesn't roll back unless needed", {
  expect_equal(calc_semester_breaks(ymd("2025-01-04")), ymd("2025-01-01"))
})
