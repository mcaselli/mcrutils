test_that("auto_dt produces a datatables object", {
  df <- data.frame(
    some_label = c("a", "b", "c"),
    some_value = c(1.1, 2.1, 3.5),
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
  dt <- auto_dt(df)
  expect_s3_class(dt, "datatables")
})
