test_that("label_quarters_short() works correctly", {
  dates <- as.Date(
    c(
      "2021-01-01", "2021-04-01", "2021-07-01", "2021-10-01",
      "2022-01-01", "2022-04-01"
    )
  )
  expect_equal(
    label_quarters_short()(dates),
    c("Q1\n2021", "Q2", "Q3", "Q4", "Q1\n2022", "Q2")
  )
})

test_that("label_quarters_short() works with non-quarter-starting dates", {
  dates <- as.Date(
    c(
      "2021-01-15", "2021-05-01", "2021-07-02", "2021-11-01",
      "2022-01-02", "2022-04-07"
    )
  )
  expect_equal(
    label_quarters_short()(dates),
    c("Q1\n2021", "Q2", "Q3", "Q4", "Q1\n2022", "Q2")
  )
})

test_that("label_quarters_short() works with NA values", {
  dates <- as.Date(
    c(
      "2021-01-01", NA, "2021-07-01", "2021-10-01",
      "2022-01-01", "2022-04-01"
    )
  )
  expect_equal(
    label_quarters_short()(dates),
    c("Q1\n2021", NA, "Q3", "Q4", "Q1\n2022", "Q2")
  )
  expect_equal(
    label_quarters_short()(as.Date(c(NA, NA, NA))),
    c(NA, NA, NA)
  )
})
