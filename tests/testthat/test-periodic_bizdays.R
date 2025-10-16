test_that("periodic_bizdays works with monthly by", {
  res <- periodic_bizdays(
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31"),
    by = "month",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 24) # 12 months * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))
  first_period <-
    res |> dplyr::slice_head() |> dplyr::select(start, end) |> as.list()
  expect_equal(
    first_period,
    list(start = as.Date("2023-01-01"), end = as.Date("2023-01-31"))
  )
})

test_that("periodic_bizdays works with quarterly by", {
  res <- periodic_bizdays(
    from = as.Date("2023-01-01"),
    to = as.Date("2023-12-31"),
    by = "quarter",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 8) # 4 quarters * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))
  first_period <-
    res |> dplyr::slice_head() |> dplyr::select(start, end) |> as.list()
  expect_equal(
    first_period,
    list(start = as.Date("2023-01-01"), end = as.Date("2023-03-31"))
  )
})

test_that("periodic_bizdays works with string dates", {
  res <- periodic_bizdays(
    from = "2023-01-01",
    to = "2023-12-31",
    by = "month",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 24) # 12 months * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))
})

test_that("periodic_bizdays works with start and end dates that are mid-period", {
  res <- periodic_bizdays(
    from = as.Date("2023-01-15"),
    to = as.Date("2023-11-20"),
    by = "quarter",
    quantlib_calendars = c("UnitedStates", "UnitedKingdom")
  )

  actual_start <- res |> head(1) |> dplyr::pull(start)
  actual_end <- res |> tail(1) |> dplyr::pull(end)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 8) # 4 quarters * 2 calendars
  expect_true(all(c("calendar", "start", "end", "business_days") %in% colnames(res)))
  expect_true(all(res$business_days > 0))

  first_period <-
    res |> dplyr::slice_head() |> dplyr::select(start, end) |> as.list()
  expect_equal(
    first_period,
    list(start = as.Date("2023-01-15"), end = as.Date("2023-04-14"))
  )

  last_period <-
    res |> dplyr::slice_tail() |> dplyr::select(start, end) |> as.list()
  expect_equal(
    last_period,
    list(start = as.Date("2023-10-15"), end = as.Date("2023-11-20"))
  )

})
