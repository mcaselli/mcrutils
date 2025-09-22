# prepare example_sales dataset for accounts_by_status()

set.seed(1234)
n <- 50

example_sales <- data.frame(
  account_id = sample(letters[1:10], n, replace = TRUE),
  order_date = sample(
    seq(as.Date("2022-01-01"), as.Date("2022-12-31"), by = "day"),
    n,
    replace = TRUE
  )
) |> arrange(order_date, account_id)

usethis::use_data(example_sales, overwrite = TRUE)
