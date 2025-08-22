test_that("guess_col_fmts()test classifies columns correctly", {
  df <- data.frame(
    some_label = c("a", "b", "c"),
    some_value = c(1, 2, 3),
    some_pct = c(0.1, 0.2, 0.3),
    some_frac = c(0.1, 0.2, 0.3),
    some_percent = c(0.1, 0.2, 0.3),
    more_numbers = c(10, 20, 30),
    more_text = c("x", "y", "z"),
    a_revenue = c(100, 200, 300),
    a_asp = c(10, 20, 30),
    a_cogs = c(50, 100, 150),
    stringsAsFactors = FALSE
  )

  col_classes <- guess_col_fmts(df)
  expect_equal(
    col_classes$numeric,
    c("some_value", "more_numbers")
  )
  expect_equal(
    col_classes$pct,
    c("some_pct", "some_frac", "some_percent")
  )
  expect_equal(
    col_classes$currency,
    c("a_revenue", "a_asp", "a_cogs")
  )
})
