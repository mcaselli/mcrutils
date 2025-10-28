test_that("adjust_to_bizday adjusts to following business day", {
  expect_equal(
    adjust_to_bizday("2025-07-04", "UnitedStates"),
    as.Date("2025-07-07")
  )
  expect_equal(
    adjust_to_bizday("2025-05-31", "UnitedStates"),
    as.Date("2025-06-02")
  )
})

test_that("adjust_to_bizday leaves working-days alone", {
  expect_equal(
    adjust_to_bizday("2025-01-15", "UnitedStates"),
    as.Date("2025-01-15")
  )
})
