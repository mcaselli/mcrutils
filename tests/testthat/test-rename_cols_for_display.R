test_that("rename_cols_for_display formats snake_case-like names", {
  x <- data.frame(
    volume_py = 1,
    abc_units = 2,
    total_cagr = 3,
    check.names = FALSE
  )

  result <- rename_cols_for_display(x)

  expect_equal(names(result), c("Volume Py", "Abc Units", "Total Cagr"))
})

test_that("rename_cols_for_display preserves user-provided acronyms", {
  x <- data.frame(
    volume_py = 1,
    abc_units = 2,
    total_cagr = 3,
    check.names = FALSE
  )

  result <- rename_cols_for_display(x, all_caps = c("PY", "ABC", "CAGR"))

  expect_equal(names(result), c("Volume PY", "ABC Units", "Total CAGR"))
})

test_that("rename_cols_for_display works with tibbles", {
  x <- dplyr::as_tibble(data.frame(
    order_date = as.Date("2026-01-01"),
    ytd_value = 10,
    check.names = FALSE
  ))

  result <- rename_cols_for_display(x, all_caps = "YTD")

  expect_s3_class(result, "tbl_df")
  expect_equal(names(result), c("Order Date", "YTD Value"))
})

test_that("rename_cols_for_display validates all_caps input", {
  x <- data.frame(value = 1)

  expect_error(
    rename_cols_for_display(x, all_caps = 1),
    "all_caps.*must be a character vector of acronyms to preserve in uppercase.*You provided an object of class"
  )
})
