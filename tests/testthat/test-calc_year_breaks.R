test_that("calc_year_breaks works", {
  expect_equal(
    calc_year_breaks(ymd(c("2000-02-01", "2002-01-14"))),
    ymd(c("2000-01-01", "2001-01-01", "2002-01-01"))
  )
})

test_that("calc_year_breaks works with a single date", {
  expect_equal(calc_year_breaks(ymd("2000-02-01")), ymd("2000-01-01"))
})

test_that("calc_year_breaks works with character input in ymd", {
  expect_equal(calc_year_breaks("2000-02-01"), ymd("2000-01-01"))
})
