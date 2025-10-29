test_that("is_bizday() works", {
  expect_equal(
    is_bizday(c("2024-07-04", "2024-07-05"), "UnitedStates"),
    c(FALSE, TRUE)
  )
  expect_equal(
    is_bizday(c("2024-07-04", "2024-07-05"), "UnitedKingdom"),
    c(TRUE, TRUE)
  )
})

test_that("is_bizday() errors for invalid calendar", {
  expect_snapshot(
    is_bizday("2024-07-05", "InvalidCalendar"),
    error = TRUE
  )
})
