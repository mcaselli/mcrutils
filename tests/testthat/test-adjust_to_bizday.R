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

test_that("the default rolls back across a month boundary", {
  # A month opening on a non-business day rolls back into the prior month
  # rather than forward. 2026-08-01 is a Saturday and 2026-08-02 a Sunday;
  # the preceding business day is Friday 2026-07-31.
  expect_equal(
    adjust_to_bizday(c("2026-08-01", "2026-08-02"), "UnitedStates"),
    as.Date(c("2026-07-31", "2026-07-31"))
  )
  # 2027-01-01 is a Friday and a US holiday, 2027-01-02 a Saturday and
  # 2027-01-03 a Sunday; all three roll back to Thursday 2026-12-31, crossing
  # a month, quarter and year boundary.
  expect_equal(
    adjust_to_bizday(c("2027-01-01", "2027-01-02", "2027-01-03"), "UnitedStates"),
    as.Date(rep("2026-12-31", 3))
  )
})

test_that("the default never rolls a date forward", {
  all_days <- seq(as.Date("2023-01-01"), as.Date("2026-12-31"), by = "day")
  adjusted <- adjust_to_bizday(all_days, "UnitedStates")
  expect_true(all(adjusted <= all_days))
  expect_true(all(is_bizday(adjusted, "UnitedStates")))
})

test_that("the default stays within a month for month-trailing non-business days", {
  # Rolling back from the end of a month cannot leave it, so these are
  # unchanged by the switch away from a "Modified" convention.
  expect_equal(
    adjust_to_bizday("2025-08-30", "UnitedStates"),
    as.Date("2025-08-29")
  )
  expect_equal(
    adjust_to_bizday("2023-12-31", "UnitedStates"),
    as.Date("2023-12-29")
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
  expect_equal(
    adjust_to_bizday("2026-08-01", "UnitedStates", bdc = "ModifiedPreceding"),
    as.Date("2026-08-03")
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
