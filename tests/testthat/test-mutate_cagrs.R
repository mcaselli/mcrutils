test_that("calculate_cagr_safe: basic math and NA/zero guards", {
  x <- c(100, 110, 121, 133.1, 146.41) # ~10% YoY compounded
  # 1-year CAGR equals simple growth
  expect_equal(
    calculate_cagr_safe(x, 1),
    c(NA_real_, 0.10, 0.10, 0.10, 0.10),
    tolerance = 1e-8
  )

  # 2-year CAGR first non-NA value
  expect_equal(
    calculate_cagr_safe(x, 2)[3],
    unname((121 / 100)^(1 / 2) - 1),
    tolerance = 1e-8
  )

  # Non-positive lagged base -> NA
  x2 <- c(0, 10, 20, 30)
  expect_true(is.na(calculate_cagr_safe(x2, 1)[2]))

  # NA propagation
  x3 <- c(100, NA, 110)
  res <- calculate_cagr_safe(x3, 1)
  expect_true(is.na(res[2]))
  expect_true(is.na(res[3]))
})

test_that("mutate_cagrs: ungrouped numeric year orders correctly and returns expected CAGRs", {
  df <- data.frame(
    year  = 2018:2022,
    value = c(100, 110, 121, 133.1, 146.41) # ~10% compounded
  )

  out <- mutate_cagrs(
    data = df,
    values = value,
    time_var = year,
    periods = c(1, 2),
    names = "{.fn}"
  )

  expect_true(all(c("cagr_1", "cagr_2") %in% names(out)))
  expect_equal(out$cagr_1, c(NA_real_, rep(0.10, 4)), tolerance = 1e-8)
  expect_equal(out$cagr_2[3:5], rep(0.10, 3), tolerance = 1e-8)
})

test_that("mutate_cagrs: grouped computation is independent per group", {
  # Construct data with DISTINCT growth rates by region:
  # APAC ~10% compounded; EMEA ~5% compounded
  df <- data.frame(
    region = rep(c("APAC", "EMEA"), each = 5),
    year = rep(2018:2022, times = 2),
    items = c(
      # APAC (10% growth)
      100.00000, 110.00000, 121.00000, 133.10000, 146.41000,
      # EMEA (5% growth)
      100.00000, 105.00000, 110.25000, 115.76250, 121.55063
    )
  )

  out <- df |>
    mutate_cagrs(
      values = items,
      time_var = year,
      group_vars = region,
      periods = c(1, 2),
      names = "{.fn}"
    )

  # Split by region and test each independently
  by_region <- split(out, out$region)

  # APAC assertions (≈10% per year)
  x_apac_1 <- by_region$APAC$cagr_1
  expect_true(is.na(x_apac_1[1]))
  expect_equal(x_apac_1[-1], rep(0.10, 4), tolerance = 1e-6)

  x_apac_2 <- by_region$APAC$cagr_2
  # First two rows NA, remaining should be ~10%
  expect_true(all(is.na(x_apac_2[1:2])))
  expect_equal(x_apac_2[3:5], rep(0.10, 3), tolerance = 1e-6)

  # EMEA assertions (≈5% per year)
  x_emea_1 <- by_region$EMEA$cagr_1
  expect_true(is.na(x_emea_1[1]))
  expect_equal(x_emea_1[-1], rep(0.05, 4), tolerance = 1e-6)

  x_emea_2 <- by_region$EMEA$cagr_2
  expect_true(all(is.na(x_emea_2[1:2])))
  expect_equal(x_emea_2[3:5], rep(0.05, 3), tolerance = 1e-6)

  # Cross-check: ensure group cagr_1 means differ (proves independence)
  mean_apac <- mean(x_apac_1, na.rm = TRUE)
  mean_emea <- mean(x_emea_1, na.rm = TRUE)
  expect_gt(mean_apac, mean_emea)
})

test_that("mutate_cagrs: Date-based time_var orders correctly", {
  df <- data.frame(
    date  = as.Date(c("2020-01-01", "2021-01-01", "2022-01-01")),
    value = c(100, 110, 121)
  )
  expect_silent(
    out <- mutate_cagrs(
      data = df,
      values = value,
      time_var = date,
      periods = 1,
      names = "{.fn}"
    )
  )
  expect_equal(out$cagr_1, c(NA_real_, 0.10, 0.10), tolerance = 1e-8)
})


test_that("mutate_cagrs: naming pattern and multiple periods", {
  df <- data.frame(
    year  = 2018:2022,
    value = c(100, 110, 121, 133.1, 146.41)
  )

  out <- mutate_cagrs(
    data = df,
    values = value,
    time_var = year,
    periods = c(1, 3, 4),
    names = "{.fn}"
  )

  expect_setequal(
    c("year", "value", "cagr_1", "cagr_3", "cagr_4"),
    names(out)
  )
  expect_true(all(is.na(out$cagr_4[1:4])))
  expect_false(is.na(out$cagr_4[5]))
})

test_that("mutate_cagrs: works without grouping (group_vars = NULL)", {
  df <- data.frame(
    year  = 2018:2021,
    items = c(100, 110, 121, 133.1)
  )
  out <- mutate_cagrs(
    data = df,
    values = items,
    time_var = year,
    periods = 2,
    names = "{.fn}"
  )
  expect_true("cagr_2" %in% names(out))
  expect_true(all(is.na(out$cagr_2[1:2])))
})

test_that("mutate_cagrs: tidy-eval grouping works with multiple columns", {
  df <- data.frame(
    region = rep(c("APAC", "EMEA"), each = 6),
    brand  = rep(rep(c("A", "B"), each = 3), times = 2),
    year   = rep(2019:2021, times = 4),
    value  = c(100, 110, 121, 80, 88, 96.8, 90, 99, 108.9, 50, 55, 60.5)
  )

  out <- mutate_cagrs(
    data = df,
    values = value,
    time_var = year,
    group_vars = c(region, brand),
    periods = 1,
    names = "{.fn}"
  )

  first_rows <- dplyr::group_by(out, region, brand) |>
    dplyr::slice_head(n = 1)
  expect_true(all(is.na(first_rows$cagr_1)))
})

# -------------------------------------------------------------------
# Snapshot tests for UI elements (cli warnings/messages)
# These snapshots will be stored under tests/testthat/_snaps/mutate_cagrs.md
# We normalize CLI output to be deterministic across environments.
# -------------------------------------------------------------------

test_that("UI snapshot: unordered factor ordering warning", {
  df <- data.frame(
    year_fac = factor(c("2018", "2019", "2020", "2021")), # unordered factor
    value    = c(100, 110, 121, 133.1)
  )

  withr::local_options(cli.num_colors = 1, cli.dynamic = FALSE)
  withr::local_envvar(CLI_NUM_COLORS = "0")

  expect_snapshot(
    invisible(
      mutate_cagrs(
        data = df,
        values = value,
        time_var = year_fac,
        periods = 1,
        names = "{.fn}",
        validate = TRUE,
        quiet = FALSE
      )
    ),
    cran = FALSE
  )
})


test_that("UI snapshot: ordered factor ordering warning", {
  df <- data.frame(
    year_fac = factor(c("2018", "2019", "2020", "2021"), ordered = TRUE), # ordered factor
    value    = c(100, 110, 121, 133.1)
  )

  withr::local_options(cli.num_colors = 1, cli.dynamic = FALSE)
  withr::local_envvar(CLI_NUM_COLORS = "0")

  expect_snapshot(
    invisible(
      mutate_cagrs(
        data = df,
        values = value,
        time_var = year_fac,
        periods = 1,
        names = "{.fn}",
        validate = TRUE,
        quiet = FALSE
      )
    ),
    cran = FALSE
  )
})

test_that("UI snapshot: unknown character format uses lexicographic fallback", {
  df <- data.frame(
    label = c("Q1-2022", "Q3-2021", "Q2-2022"), # unknown format
    value = c(100, 90, 110)
  )

  withr::local_options(cli.num_colors = 1, cli.dynamic = FALSE)
  withr::local_envvar(CLI_NUM_COLORS = "0")

  expect_snapshot(
    invisible(
      mutate_cagrs(
        data = df,
        values = value,
        time_var = label,
        periods = 1,
        names = "{.fn}",
        validate = TRUE,
        quiet = FALSE
      )
    ),
    cran = FALSE
  )
})

test_that("UI snapshot: duplicate (group, time) rows warning", {
  df <- data.frame(
    region = c("APAC", "APAC", "APAC"),
    year   = c(2020, 2020, 2021), # duplicate time within group
    value  = c(100, 100, 110)
  )

  withr::local_options(cli.num_colors = 1, cli.dynamic = FALSE)
  withr::local_envvar(CLI_NUM_COLORS = "0")

  expect_snapshot(
    invisible(
      mutate_cagrs(
        data = df,
        values = value,
        time_var = year,
        group_vars = c(region),
        periods = 1,
        names = "{.fn}",
        validate = TRUE,
        quiet = FALSE
      )
    ),
    cran = FALSE
  )
})

test_that("UI snapshot: gaps in time sequence warning", {
  df <- data.frame(
    year  = c(2018, 2020, 2021), # missing 2019
    value = c(100, 110, 121)
  )

  withr::local_options(cli.num_colors = 1, cli.dynamic = FALSE)
  withr::local_envvar(CLI_NUM_COLORS = "0")

  expect_snapshot(
    invisible(
      mutate_cagrs(
        data = df,
        values = value,
        time_var = year,
        periods = 1,
        names = "{.fn}",
        validate = TRUE,
        quiet = FALSE
      )
    ),
    cran = FALSE
  )
})
