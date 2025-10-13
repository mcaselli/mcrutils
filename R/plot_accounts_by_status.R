#' Plot Count of Accounts by Status Over Time
#'
#' @description
#' `r lifecycle::badge('experimental')`
#'
#' This function generates a line plot visualizing the counts of accounts by
#' their status over time. It uses the [accounts_by_status()] function to
#' categorize accounts and then creates a plot using `ggplot2`.
#'
#' @inheritParams accounts_by_status
#' @param lost either "detailed" or "simple", if "detailed", terminally lost and
#'   temporarily lost accounts are shown separately, if "simple", they are
#'   combined into a single lost category. Defaults to "detailed".
#' @param force_final_period_complete Logical, if TRUE, treat the final period
#'   as complete even if it may not be. This forces the final period to be
#'   displayed with solid lines, even if the period includes dates greater than
#'   the final `order_date` in `data`.
#' @param include_cumulative Logical, if TRUE, include the cumulative account
#'   counts in the plot. Defaults to TRUE.
#' @return A ggplot2 object: a line plot of the count of accounts of each status
#'   over time (active, new, returning, temporarily lost, terminally lost,
#'   regained, and optionally cumulative).  If `force_final_period_complete` is
#'   FALSE, the final period will be displayed with a dashed line if the period
#'   includes dates greater than the final `order_date` in `data`.
#' @examples
#' example_sales |>
#'   plot_accounts_by_status(account_id, order_date, by = "quarter")
#' @export
plot_accounts_by_status <- function(data, account_id, order_date, by = "month",
                                    lost = c("detailed", "simple"),
                                    force_final_period_complete = FALSE,
                                    include_cumulative = TRUE) {
  lost <- rlang::arg_match(lost)

  latest_order <- data |>
    dplyr::pull({{ order_date }}) |>
    max(na.rm = TRUE)

  churn_summary <-
    data |>
    accounts_by_status({{ account_id }}, {{ order_date }}, by = by, with_counts = TRUE) |>
    mutate(incomplete_period = .data$period_end > latest_order) |>
    (\(x) if (!include_cumulative) {
      x |> select(-dplyr::contains("cumulative"))
    } else {
      x
    })() |>
    (\(x) if (lost == "simple") {
      x |>
        mutate(
          n_lost = .data$n_terminally_lost + .data$n_temporarily_lost,
        )  |>
         select(-"n_temporarily_lost", -"n_terminally_lost")
    } else {
      x
    })()

  if (force_final_period_complete) {
    churn_summary$incomplete_period <- FALSE
  }

  munge_to_plot <- function(churn_summary, by) {
    churn_summary |>
      rename(!!by := "period_start") |>
      select(!!by, "incomplete_period", dplyr::starts_with("n_")) |>
      # negate the lost counts for visualization
      mutate(across(contains("lost"), ~ -.x)) |>
      # pivot to prepare for ggplot
      pivot_longer(dplyr::starts_with("n_"), names_to = "status", values_to = "count") |>
      mutate(status = stringr::str_remove(.data$status, "n_")) |>
      mutate(status = factor(.data$status, levels = c("active", "returning", "new", "regained", "lost", "temporarily_lost", "terminally_lost", "cumulative"))) |>
      mutate(status = fct_relabel(.data$status, ~ stringr::str_to_title(stringr::str_replace_all(.x, "_", " "))))
  }

  churn_summary_complete_periods <- churn_summary |>
    dplyr::filter(!.data$incomplete_period)

  if (any(churn_summary$incomplete_period)) {
    # include the last complete period to get a line segment connecting the last
    # complete period with the first incomplete period.
    churn_summary_incomplete_periods <- rbind(
      tail(churn_summary_complete_periods, 1),
      (churn_summary |> dplyr::filter(.data$incomplete_period))
    )
    churn_summary_incomplete_periods <- munge_to_plot(churn_summary_incomplete_periods, by)
  } else {
    churn_summary_incomplete_periods <- NULL
  }

  churn_summary_complete_periods <- munge_to_plot(churn_summary_complete_periods, by)

  churn_summary_complete_periods |>
    ggplot2::ggplot(ggplot2::aes(.data[[by]], .data$count, color = .data$status)) +
    ggplot2::geom_line(linewidth = 1.2) +
    {
      if (!is.null(churn_summary_incomplete_periods)) {
        ggplot2::geom_line(
          data = churn_summary_incomplete_periods,
          linewidth = 1.2, linetype = "dashed"
        )
      }
    } +
    ggplot2::scale_color_manual(
      values = c(
        "Active" = "#1f78b4",
        "New" = "#33a02c",
        "Returning" = "#a6cee3",
        "Lost" = "yellow",
        "Temporarily Lost" = "#fb9a99",
        "Terminally Lost" = "#e31a1c",
        "Regained" = "#b2df8a",
        "Cumulative" = "#7f7f7f"
      ),
      name = NULL
    ) +
    ggplot2::theme_minimal()
}
