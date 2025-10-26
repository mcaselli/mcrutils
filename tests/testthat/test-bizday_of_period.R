test_that("bizday_of_period works", {
  bizdays::load_quantlib_calendars("UnitedStates",
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31")
  )
  expect_equal(
    bizday_of_period(as.Date("2023-06-15"), "UnitedStates", period = "month"),
    10
  )
  expect_equal(
    bizday_of_period(as.Date("2023-06-15"), "UnitedStates", period = "quarter"),
    52
  )
  expect_equal(
    bizday_of_period(as.Date("2023-06-15"), "UnitedStates", period = "year"),
    114
  )
})
