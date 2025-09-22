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



