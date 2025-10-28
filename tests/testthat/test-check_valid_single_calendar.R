test_that("check_valid_single_calendar() works", {
  expect_snapshot(
    check_valid_single_calendar(123),
    error = TRUE
  )
  expect_snapshot(
    check_valid_single_calendar(c("UnitedStates", "Germany")),
    error = TRUE
  )
  expect_snapshot(
    check_valid_single_calendar("InvalidCalendarName"),
    error = TRUE
  )
  expect_silent(
    check_valid_single_calendar("UnitedStates")
  )
})
