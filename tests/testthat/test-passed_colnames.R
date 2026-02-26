test_that("passed_colnames() works", {
  f <- function(data, var) {
    passed_colnames(data, rlang::enquo(var))
  }
  expect_equal(
    f(mtcars, cyl),
    "cyl"
  )

  # null var
  expect_equal(
    f(mtcars, NULL),
    character(0)
  )

  # multiple vars
  expect_equal(
    f(mtcars, c(cyl, gear)),
    c("cyl", "gear")
  )

  # tidyselect helpers
  expect_equal(
    f(mtcars, starts_with("c")),
    c("cyl", "carb")
  )

  # var not present in data -> error
  expect_error(
    f(mtcars, not_a_col)
  )
})
