test_that("bizdays_between() works", {
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedStates"),
    10
  )
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedKingdom"),
    11
  )
})

test_that("bizdays_between() handles reversed dates", {
  expect_equal(
    bizdays_between("2025-07-15", "2025-07-01", "UnitedStates"),
    -10
  )
  expect_equal(
    bizdays_between("2025-07-15", "2025-07-01", "UnitedKingdom"),
    -11
  )
})

test_that("bizdays_between() errors on bad calendar", {
  expect_snapshot(
    bizdays_between("2025-07-01", "2025-07-15", "NonExistentCalendar"),
    error = TRUE
  )
})
