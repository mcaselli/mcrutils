test_that("breaks_integer produces integer breaks for ranges around 10", {
  breaks_0_10 <- mcrutils:::breaks_integer()(c(0, 10))
  breaks_0_11 <- mcrutils:::breaks_integer()(c(0, 11))
  breaks_1_9 <- mcrutils:::breaks_integer()(c(1, 9))

  expect_true(all(abs(breaks_0_10 - round(breaks_0_10)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_0_11 - round(breaks_0_11)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_1_9 - round(breaks_1_9)) < sqrt(.Machine$double.eps)))
})

test_that("breaks_integer produces integer breaks for very small ranges", {
  breaks_0_1 <- mcrutils:::breaks_integer()(c(0, 1))
  breaks_0_2 <- mcrutils:::breaks_integer()(c(0, 2))
  breaks_5_6 <- mcrutils:::breaks_integer()(c(5, 6))

  expect_true(all(abs(breaks_0_1 - round(breaks_0_1)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_0_2 - round(breaks_0_2)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_5_6 - round(breaks_5_6)) < sqrt(.Machine$double.eps)))
})

test_that("breaks_integer produces integer breaks for degenerate data", {
  breaks_5_5 <- mcrutils:::breaks_integer()(c(5, 5))
  breaks_0_0 <- mcrutils:::breaks_integer()(c(0, 0))

  expect_true(all(abs(breaks_5_5 - round(breaks_5_5)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_0_0 - round(breaks_0_0)) < sqrt(.Machine$double.eps)))
})

test_that("breaks_integer produces integer breaks for negative ranges", {
  breaks_minus_5_5 <- mcrutils:::breaks_integer()(c(-5, 5))
  breaks_minus_10_minus_1 <- mcrutils:::breaks_integer()(c(-10, -1))

  expect_true(all(abs(breaks_minus_5_5 - round(breaks_minus_5_5)) < sqrt(.Machine$double.eps)))
  expect_true(all(abs(breaks_minus_10_minus_1 - round(breaks_minus_10_minus_1)) < sqrt(.Machine$double.eps)))
})

test_that("scale_x_integer returns a continuous position scale", {
  result <- scale_x_integer()

  expect_s3_class(result, "ScaleContinuousPosition")
})

test_that("scale_y_integer returns a continuous position scale", {
  result <- scale_y_integer()

  expect_s3_class(result, "ScaleContinuousPosition")
})

test_that("scale_integer forwards scale_x_continuous arguments", {
  result <- scale_x_integer(limits = c(0, 10), position = "top")

  expect_equal(result$limits, c(0, 10))
  expect_identical(result$position, "top")
})

test_that("scale_integer errors when breaks is supplied", {
  expect_error(
    scale_x_integer(breaks = c(0, 5, 10)),
    "not supported"
  )

  expect_error(
    scale_y_integer(breaks = c(0, 5, 10)),
    "not supported"
  )
})

test_that("default continuous breaks around 10 can include decimals", {
  default_breaks <- scales::breaks_extended()(c(0, 10))

  expect_true(any(abs(default_breaks - round(default_breaks)) > sqrt(.Machine$double.eps)))
})
