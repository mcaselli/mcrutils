test_that("detect_hidden_logicals works", {
  df <- data.frame(
    logical_char = c("T", "F", "T"),
    logical_factor = factor(c("TRUE", "FALSE", "TRUE")),
    non_logical_char = c("a", "b", "c"),
    non_logical_factor = factor(c("x", "y", "z")),
    mixed_char = c("T", "F", "a"),
    mixed_factor = factor(c("TRUE", "FALSE", "x")),
    numeric_col = c(1.1, 2.2, 3.3),
    logical_char_with_na = c("T", "F", NA),
    logical_factor_with_na = factor(c("TRUE", "FALSE", NA)),
    stringsAsFactors = FALSE
  )

  expect_equal(
    detect_hidden_logicals(df),
    c("logical_char", "logical_char_with_na", "logical_factor", "logical_factor_with_na")
  )
})
