test_that("bizday_of_period works", {
  # see https://www.timeanddate.com/calendar/?year=2023&country=1 for a calendar
  # with holidays highlighted
  expect_equal(
    bizday_of_period(c("2025-06-16", "2025-06-17"), "UnitedStates", period = "month"),
    c(11, 12)
  )
  expect_equal(
    bizday_of_period(c("2025-06-16", "2025-06-17"), "UnitedStates", period = "quarter"),
    c(54, 55)
  )
  expect_equal(
    bizday_of_period(c("2025-06-16", "2025-06-17"), "UnitedStates", period = "year"),
    c(115, 116)
  )
})

test_that("bizday_of_period() returns 1 for a period-starting business day", {
  expect_equal(
    bizday_of_period(as.Date("2023-03-01"), # a working Wednesday
      "UnitedStates",
      period = "month"
    ),
    1
  )
})

test_that("a period starting on a weekend warns", {
  expect_snapshot(
    bizday_of_period(seq(as.Date("2023-04-01"), by = "day", length.out = 4), # a saturday
      "UnitedStates",
      period = "month"
    )
  )
})

test_that("bizday_of_period() errors on bad calendar", {
  expect_snapshot(
    bizday_of_period(as.Date("2023-06-15"),
      "NonExistentCalendar",
      period = "month"
    ),
    error = TRUE
  )
})
