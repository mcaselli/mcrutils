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
