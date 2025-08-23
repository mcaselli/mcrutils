test_that("calc_quarter_breaks works", {
  expect_equal(
    calc_quarter_breaks(ymd(c("2000-04-04", "2001-02-05"))),
    ymd(c(
      "2000-04-01", "2000-07-01", "2000-10-01",
      "2001-01-01"
    ))
  )
})

test_that("calc_quarter_breaks returns a single date for a single date input", {
  expect_equal(calc_quarter_breaks(ymd("2025-09-04")), ymd("2025-07-01"))
})
