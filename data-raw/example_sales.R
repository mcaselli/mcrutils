# prepare example_sales dataset for accounts_by_status()

set.seed(1234)
n <- 128

example_sales <- data.frame(
  # first cohort across entire time span
  account_id = sample(letters[1:4], n, replace = TRUE),
  order_date = sample(
    seq(as.Date("2022-01-01"), as.Date("2023-12-31"), by = "day"),
    n,
    replace = TRUE
  )
) |>
  # second cohort who leaves
  rbind(data.frame(
    account_id = sample(letters[5:9], n/2, replace = TRUE),
    order_date = sample(
      seq(as.Date("2022-01-01"), as.Date("2023-05-01"), by = "day"),
      n/2,
      replace = TRUE
    )
  )) |>
  # add a third cohort entering later
  rbind(data.frame(
    account_id = sample(letters[10:13], n/2, replace = TRUE),
    order_date = sample(
      seq(as.Date("2022-08-01"), as.Date("2023-12-31"), by = "day"),
      n/2,
      replace = TRUE
    )
  )) |>
  arrange(order_date, account_id)

usethis::use_data(example_sales, overwrite = TRUE)
