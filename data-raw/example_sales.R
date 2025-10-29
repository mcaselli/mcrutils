# prepare example_sales dataset for accounts_by_status()


simulate_acct_orders <- function(start_date, end_date, orders_per_month,
                                 ramp_up = TRUE, ramp_down = FALSE,
                                 ql_calendar = "UnitedStates") {
  dates <- seq(as.Date(start_date), as.Date(end_date), by = "day")
  working_days <- dates[is_bizday(dates, cal = ql_calendar)]

  n_days <- length(dates)
  n_orders <- round(orders_per_month * (n_days / 30.44)) # average days per month

  if (ramp_up) {
    ramp_up_length <- min(120, round(0.1 * n_days))
    ramp_up <- seq(0.25, 1, length.out = ramp_up_length)
  } else {
    ramp_up <- numeric(0)
  }
  if (ramp_down) {
    ramp_down_length <- min(120, round(0.2 * n_days))
    ramp_down <- seq(1, 0.1, length.out = ramp_down_length)
  } else {
    ramp_down <- numeric(0)
  }

  probs <- c(ramp_up, rep(1, n_days - length(ramp_up) - length(ramp_down)), ramp_down)

  # orders should be less likely on non-working days
  wd_probs <- tibble(
    dates = dates,
    working = dates %in% working_days
  ) |>
    dplyr::mutate(wd_prob = ifelse(working, 1, 0.05)) |>
    dplyr::pull(wd_prob)

  probs <- probs * wd_probs
  probs <- probs / sum(probs)

  sampled_dates <- sample(dates, n_orders, replace = TRUE, prob = probs)
  return(sampled_dates)
}


data_start <- as.Date("2022-01-01")
data_end <- as.Date("2024-12-20")


# create a data.frame of account parameters as input to simulate_acct_orders()
set.seed(1234)
n_accts <- 32


n_persistent <- 5

persistent_accts <- data.frame(
  account_id = paste0("p_", seq(1, n_persistent)),
  start_date = data_start,
  end_date = data_end,
  orders_per_month = sample(seq(1, 7), n_persistent, replace = TRUE),
  ramp_up = FALSE,
  ramp_down = FALSE,
  market = "United States"
)

n_joiners <- 12

joiner_accts <- data.frame(
  account_id = paste0("j_", seq(1, n_joiners)),
  start_date = sample(seq(data_start, data_end, by = "day"), n_joiners, replace = TRUE),
  end_date = data_end,
  orders_per_month = sample(seq(1, 7), n_joiners, replace = TRUE),
  ramp_up = TRUE,
  ramp_down = FALSE,
  market = sample(
    c("United States", "Germany"),
    n_joiners,
    replace = TRUE,
    prob = c(0.5, 0.5)
  )
)

n_leavers <- 20
leaver_accts <- data.frame(
  account_id = paste0("l_", seq(1, n_leavers)),
  start_date = data_start,
  # start_date = sample(seq(data_start, data_end-90, by = "day"), n_leavers, replace = TRUE),
  # end_date = pmin(start_date + round(rnorm(n_leavers, mean = 180, sd = 60)),
  # data_end),
  end_date = sample(seq(data_start, data_end, by = "day"), n_leavers, replace = TRUE),
  orders_per_month = sample(seq(1, 7), n_leavers, replace = TRUE),
  ramp_up = FALSE,
  ramp_down = TRUE,
  market = sample(
    c("United States", "Germany"),
    n_leavers,
    replace = TRUE,
    prob = c(0.5, 0.5)
  )
)

n_late_joiners <- 14
late_joiner_accts <- data.frame(
  account_id = paste0("lj_", seq(1, n_late_joiners)),
  start_date = sample(
    seq(data_start + (data_end - data_start) / 3,
      data_start + (data_end - data_start) / 3 + 120,
      by = "day"
    ),
    n_late_joiners,
    replace = TRUE
  ),
  end_date = data_end,
  orders_per_month = sample(seq(1, 7), n_late_joiners, replace = TRUE),
  ramp_up = TRUE,
  ramp_down = FALSE,
  market = sample(
    c("United States", "Germany"),
    n_late_joiners,
    replace = TRUE,
    prob = c(0.1, 0.9)
  )
)

n_quit_wave <- 12
quit_wave_accts <- data.frame(
  account_id = paste0("qw_", seq(1, n_quit_wave)),
  start_date = data_start,
  end_date = sample(seq(data_start + 650, data_start + 750, by = "day"), n_quit_wave, replace = TRUE),
  orders_per_month = sample(seq(1, 7), n_quit_wave, replace = TRUE),
  ramp_up = FALSE,
  ramp_down = TRUE,
  market = "United States"
)


acct_params <- dplyr::bind_rows(
  persistent_accts,
  joiner_accts,
  leaver_accts,
  late_joiner_accts,
  quit_wave_accts
)


example_sales_raw <- acct_params |>
  dplyr::rowwise() |>
  mutate(
    order_dates = list(simulate_acct_orders(start_date, end_date, orders_per_month, ramp_up, ramp_down))
  ) |>
  select(account_id, market, order_dates) |>
  tidyr::unnest(cols = order_dates) |>
  rename(order_date = order_dates) |>
  dplyr::arrange(order_date, account_id) |>
  mutate(
    account_num = factor(account_id) |> forcats::fct_inorder() |> as.numeric(),
    account_num = paste0("a", account_num),
    account_group = stringr::str_extract(account_id, "^[a-z]+"),
    units_ordered = rpois(n(), lambda = 1) + 1
  )


example_sales <- example_sales_raw |>
  select(account_id, market, order_date, units_ordered)

usethis::use_data(example_sales, overwrite = TRUE)
