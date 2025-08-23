test_that("breaks_quarters works with a single date", {
  expect_equal(
    breaks_quarters()(ymd("2025-09-04")),
    ymd("2025-07-01")
  )
})

test_that("breaks_quarters works with a range of dates within one quarter", {
  expect_equal(
    breaks_quarters()(ymd(c("2025-07-04", "2025-09-01"))),
    ymd("2025-07-01")
  )
})

test_that("breaks_quarters works with a short multi-quarter range of dates", {
  expect_equal(
    breaks_quarters()(ymd(c("2025-09-04", "2025-10-01"))),
    ymd(c("2025-07-01", "2025-10-01"))
  )
})

test_that("breaks_quarters returns a reasonable number of breaks with a longer range of dates", {
  expect_lt(
    abs(length(breaks_quarters()(ymd(c("2020-01-01", "2024-10-01")))) - 9),
    9 / 2
  )
  expect_lt(
    abs(length(breaks_quarters()(ymd(c("2020-01-01", "2025-10-01")))) - 9),
    9 / 2
  )
})

test_that("breaks_quarters works with limits typical of default ggplot scale expansion", {
  expect_equal(
    breaks_quarters()(as.Date(c("2000-11-25", "2003-02-06"))),
    ymd(c(
      "2000-10-01",
      "2001-01-01", "2001-04-01", "2001-07-01", "2001-10-01",
      "2002-01-01", "2002-04-01", "2002-07-01", "2002-10-01",
      "2003-01-01"
    ))
  )
})

test_that("breaks_quarters works with valid monthly fixed widths", {
  expect_equal(
    breaks_quarters(width = "3 months")(
      ymd(c("2005-02-14", "2006-01-01"))
    ),
    ymd(c(
      "2005-01-01", "2005-04-01", "2005-07-01", "2005-10-01",
      "2006-01-01"
    ))
  )
  expect_equal(
    breaks_quarters(width = "6 months")(
      ymd(c("2005-02-14", "2006-01-01"))
    ),
    ymd(c(
      "2005-01-01", "2005-07-01",
      "2006-01-01"
    ))
  )
  expect_equal(
    breaks_quarters(width = "12 months")(
      ymd(c("2005-02-14", "2006-01-01"))
    ),
    ymd(c(
      "2005-01-01",
      "2006-01-01"
    ))
  )
})

test_that("breaks_quarters errors with invalid monthly width", {
  expect_error(
    breaks_quarters(width = "2 months")(
      ymd(c("2005-02-14", "2006-01-01"))
    ),
    "Invalid width for breaks_quarters. If unit is months, value must be 3, 6 or 12"
  )
})

test_that("downsampling returns semester start dates (not Q2 and Q4)", {
  expect_equal(
    breaks_quarters()(ymd(c("2000-04-04", "2004-04-01"))),
    ymd(c(
      "2000-01-01", "2000-07-01",
      "2001-01-01", "2001-07-01",
      "2002-01-01", "2002-07-01",
      "2003-01-01", "2003-07-01",
      "2004-01-01"
    ))
  )
})
