
test_that("normalize_logicals converts columns correctly", {
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

  normalized_df <- normalize_logicals(df, quiet = TRUE)
  expect_setequal(
    names(which(sapply(normalized_df, is.logical))),
    c("logical_char", "logical_char_with_na", "logical_factor", "logical_factor_with_na")
  )
  expect_setequal(
    names(which(sapply(normalized_df, is.character))),
    c("non_logical_char", "mixed_char")
  )
  expect_setequal(
    names(which(sapply(normalized_df, is.factor))),
    c("non_logical_factor", "mixed_factor")
  )
  expect_true(inherits(normalized_df$numeric_col, "numeric"))
})

test_that("normalize_logicals handles no logical columns", {
  df <- data.frame(
    non_logical_char = c("a", "b", "c"),
    non_logical_factor = factor(c("x", "y", "z")),
    numeric_col = c(1.1, 2.2, 3.3),
    stringsAsFactors = FALSE
  )

  normalized_df <- normalize_logicals(df, quiet = TRUE)
  expect_equal(normalized_df, df)
})

test_that("normalize_logicals suppresses messages when quiet = TRUE", {
  df <- data.frame(
    logical_char = c("T", "F", "T"),
    logical_factor = factor(c("TRUE", "FALSE", "TRUE")),
    stringsAsFactors = FALSE
  )

  expect_silent(normalize_logicals(df, quiet = TRUE))
})

test_that("normalize_logicals informs about converted columns", {
  df <- data.frame(
    logical_char = c("T", "F", "T"),
    logical_factor = factor(c("TRUE", "FALSE", "TRUE")),
    stringsAsFactors = FALSE
  )

  expect_message(
    normalize_logicals(df, quiet = FALSE),
    "Converted.*logical"
  )
})
