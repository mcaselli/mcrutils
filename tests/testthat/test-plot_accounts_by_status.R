test_that("plot_accounts_by_status() with incomplete final period", {
  vdiffr::expect_doppelganger(
    "incomplete_final",
    example_sales |>
      plot_accounts_by_status(account_id, order_date, by = "quarter")
  )
})

test_that("plot_accounts_by_status() can force a final period to display as complete", {
  vdiffr::expect_doppelganger(
    "force_complete_final",
    example_sales |>
      plot_accounts_by_status(account_id, order_date, by = "quarter", force_final_period_complete = TRUE)
  )
})


test_that("plot_accounts_by_status() displays a complete final period as solid", {
  vdiffr::expect_doppelganger(
    "complete_final",
    example_sales |>
      rbind(data.frame(
        account_id = "f",
        order_date = as.Date("2024-12-31")
      )) |>
      plot_accounts_by_status(account_id, order_date, by = "quarter")
  )
})



test_that("plot_accounts_by_status() can exclude cumulative", {
  vdiffr::expect_doppelganger(
    "without_cumulative",
    example_sales |>
      plot_accounts_by_status(account_id, order_date, by = "quarter", include_cumulative = FALSE)
  )
})
