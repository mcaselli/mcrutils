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

test_that("bizdays_between() respects include_first and include_last", {
  # baseline: both endpoints included (default)
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedStates",
      include_first = TRUE, include_last = TRUE
    ),
    10
  )
  # exclude first only
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedStates",
      include_first = FALSE, include_last = TRUE
    ),
    9
  )
  # exclude last only
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedStates",
      include_first = TRUE, include_last = FALSE
    ),
    9
  )
  # exclude both endpoints
  expect_equal(
    bizdays_between("2025-07-01", "2025-07-15", "UnitedStates",
      include_first = FALSE, include_last = FALSE
    ),
    8
  )
})
