test_that("adjust_to_bizday rolls back to the preceding business day by default", {
  # 2025-07-04 is a Friday and a US holiday; the preceding business day is
  # Thursday 2025-07-03, in the same month.
  expect_equal(
    adjust_to_bizday("2025-07-04", "UnitedStates"),
    as.Date("2025-07-03")
  )
  # 2025-05-31 is a Saturday; the preceding business day is Friday 2025-05-30.
  expect_equal(
    adjust_to_bizday("2025-05-31", "UnitedStates"),
    as.Date("2025-05-30")
  )
})

test_that("adjust_to_bizday leaves working-days alone", {
  expect_equal(
    adjust_to_bizday("2025-01-15", "UnitedStates"),
    as.Date("2025-01-15")
  )
})

test_that("the default convention never moves a date out of its month", {
  # A month-end weekend rolls back rather than into the next month. Every
  # quarter and year boundary is also a month boundary, so month-safety is
  # also quarter- and year-safety.
  expect_equal(
    adjust_to_bizday("2025-08-30", "UnitedStates"),
    as.Date("2025-08-29")
  )
  expect_equal(
    adjust_to_bizday("2023-12-31", "UnitedStates"),
    as.Date("2023-12-29")
  )
  all_days <- seq(as.Date("2023-01-01"), as.Date("2026-12-31"), by = "day")
  adjusted <- adjust_to_bizday(all_days, "UnitedStates")
  expect_equal(format(adjusted, "%Y-%m"), format(all_days, "%Y-%m"))
})

test_that("a month that opens on a weekend rolls forward instead", {
  # Rolling back would leave the month, so "Modified" forces it forward. The
  # volume belongs to the new month and its first business day is the only
  # slot available.
  expect_equal(
    adjust_to_bizday(c("2026-08-01", "2026-08-02"), "UnitedStates"),
    as.Date(c("2026-08-03", "2026-08-03"))
  )
})

test_that("bdc selects other QuantLib conventions", {
  expect_equal(
    adjust_to_bizday("2025-08-30", "UnitedStates", bdc = "Following"),
    as.Date("2025-09-02")
  )
  expect_equal(
    adjust_to_bizday("2025-08-30", "UnitedStates", bdc = "Preceding"),
    as.Date("2025-08-29")
  )
  expect_equal(
    adjust_to_bizday("2025-07-04", "UnitedStates", bdc = "ModifiedFollowing"),
    as.Date("2025-07-07")
  )
})

test_that("an unknown bdc is rejected", {
  expect_error(
    adjust_to_bizday("2025-08-30", "UnitedStates", bdc = "Sideways"),
    class = "rlang_error"
  )
})

test_that("the calendar in effect before the call is restored", {
  qlcal::setCalendar("UnitedKingdom")
  adjust_to_bizday("2025-07-04", "UnitedStates")
  expect_equal(qlcal::getId(), "UnitedKingdom")
})
