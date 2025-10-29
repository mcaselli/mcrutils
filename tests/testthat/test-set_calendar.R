test_that("with_calendar() works", {
  expect_equal(
    c(
      qlcal::isBusinessDay(as.Date("2024-07-04")),
      with_calendar(
        "UnitedStates",
        qlcal::isBusinessDay(as.Date("2024-07-04"))
      )
    ),
    c(TRUE, FALSE)
  )
})
