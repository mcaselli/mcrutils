test_that("active_accounts_in_range() works", {
  df <- data.frame(
    account_id = c("A", "B", "C", "A", "D", "E", "B", "F"),
    order_date = as.Date(c(
      "2022-01-01", "2022-01-05", "2022-01-10", "2022-02-01",
      "2022-02-15", "2022-03-01", "2022-03-05", "2022-04-01"
    ))
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-01-01"),
      end_date = as.Date("2022-01-31")
    ),
    c("A", "B", "C")
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-02-01"),
      end_date = as.Date("2022-02-28")
    ),
    c("A", "D")
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-03-01"),
      end_date = as.Date("2022-03-31")
    ),
    c("B", "E")
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-04-01"),
      end_date = as.Date("2022-04-30")
    ),
    c("F")
  )

})


test_that("active_accounts_in_range() returns empty vector when no orders in range", {
  df <- data.frame(
    account_id = c("A", "B", "C"),
    order_date = as.Date(c("2022-01-01", "2022-01-05", "2022-01-10"))
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-02-01"),
      end_date = as.Date("2022-02-28")
    ),
    character(0)
  )
})


test_that("active_accounts_in_range() works with factors", {
  df <- data.frame(
    account_id = factor(c("A", "B", "C", "A", "D", "E", "B", "F")),
    order_date = as.Date(c(
      "2022-01-01", "2022-01-05", "2022-01-10", "2022-02-01",
      "2022-02-15", "2022-03-01", "2022-03-05", "2022-04-01"
    ))
  )

  expect_equal(
    active_accounts_in_range(
      account_id = df$account_id,
      order_date = df$order_date,
      start_date = as.Date("2022-01-01"),
      end_date = as.Date("2022-01-31")
    ),
    factor(c("A", "B", "C"), levels = levels(df$account_id))
  )
})


test_that("accounts_by_status() properly calculates period_start and period_end",
{
  orders <- data.frame(
    account_id = c("A", "B", "C"),
    order_date = as.Date(c(
      "2022-09-15", "2023-01-10", "2022-10-05"
    ))
  )

  result_monthly <- accounts_by_status(orders$account_id, orders$order_date, by = "month")
  expect_equal(result_monthly$period_start, as.Date(c("2022-09-01", "2022-10-01", "2022-11-01", "2022-12-01", "2023-01-01")))
  expect_equal(result_monthly$period_end, as.Date(c("2022-09-30", "2022-10-31", "2022-11-30", "2022-12-31", "2023-01-31")))

  result_quarterly <- accounts_by_status(orders$account_id, orders$order_date, by = "quarter")
  expect_equal(result_quarterly$period_start, as.Date(c("2022-07-01", "2022-10-01", "2023-01-01")))
  expect_equal(result_quarterly$period_end, as.Date(c("2022-09-30", "2022-12-31", "2023-03-31")))

})


test_that("accounts_by_status() correctly lists new accounts", {

  orders <- dplyr::tribble(
    ~account_id, ~order_date,
    "A", "2022-01-15",
    "B", "2022-01-20",
    "A", "2022-02-10",
    "C", "2022-02-15",
    "D", "2022-03-05",
    "E", "2022-03-25",
    "B", "2022-04-10",
    "F", "2022-04-15"
  ) |> dplyr::mutate(order_date = as.Date(order_date))

  result <- accounts_by_status(orders$account_id, orders$order_date)

  expected <- dplyr::tribble(
    ~period_start, ~new,
    as.Date("2022-01-01"), c("A", "B"),
    as.Date("2022-02-01"), c("C"),
    as.Date("2022-03-01"), c("D", "E"),
    as.Date("2022-04-01"), c("F")
  ) |> data.frame()

  expect_equal(result |> dplyr::select(period_start, new), expected)

  expected_quarterly <- dplyr::tribble(
    ~period_start, ~new,
    as.Date("2022-01-01"), c("A", "B", "C", "D", "E"),
    as.Date("2022-04-01"), c("F")
  ) |> data.frame()

  result_quarterly <- accounts_by_status(orders$account_id, orders$order_date, by = "quarter")

  expect_equal(result_quarterly |> dplyr::select(period_start, new), expected_quarterly)

})


