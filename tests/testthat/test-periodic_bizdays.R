test_that("periodic_bizdays works with monthly by", {
  res <- periodic_bizdays(
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31"),
    by = "month",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 24) # 12 months * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))
})

test_that("periodic_bizdays works with quarterly by", {
  res <- periodic_bizdays(
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31"),
    by = "quarter",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 8) # 4 quarters * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))
})
