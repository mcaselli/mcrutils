test_that("load_calendars() works", {
  dates <- as.Date(c("2022-05-15", "2023-08-20", "2024-01-10"))
  calendars <- c("UnitedStates", "UnitedKingdom", "Germany")
  expect_silent(
    load_calendars(dates, calendars)
  )
  expect_snapshot(
    load_calendars(dates, calendars, quiet = FALSE)
  )
  expect_equal(bizdays::bizdays(
    from = as.Date("2024-05-01"),
    to = as.Date("2024-05-15"),
    cal = "QuantLib/UnitedStates"
  ), 10)
})
