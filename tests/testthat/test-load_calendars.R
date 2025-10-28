test_that("load_calendars() works", {
  dates <- as.Date(c("2022-05-15", "2023-08-20", "2024-01-10"))
  calendars <- c("UnitedStates", "UnitedKingdom", "Germany")
  expect_silent(
    load_calendars(dates, calendars)
  )

  ql_names <- paste0("QuantLib/", calendars)
  avail_calendars <- bizdays::calendars()
  expect_in(ql_names, names(avail_calendars))

  expect_snapshot(
    load_calendars(dates, calendars, quiet = FALSE)
  )
  expect_equal(bizdays::bizdays(
    from = as.Date("2024-05-01"),
    to = as.Date("2024-05-15"),
    cal = "QuantLib/UnitedStates"
  ), 11)
})


test_that("load_calendars(..., quiet=FALSE) shows messages", {
  dates <- as.Date(c("2022-05-15", "2023-08-20", "2024-01-10"))
  calendars <- c("UnitedStates", "UnitedKingdom", "Germany")
  expect_snapshot(
    load_calendars(dates, calendars, quiet = FALSE)
  )
})

test_that("load_calendars() makes calendars non-financial by default", {
  dates <- c("2022-05-15", "2023-08-20", "2024-01-10") # character vector
  calendars <- c("UnitedStates", "UnitedKingdom")

  load_calendars(dates, calendars)

  avail_calendars <- bizdays::calendars()

  ql_names <- paste0("QuantLib/", calendars)
  avail_calendars <- bizdays::calendars()
  expect_equal(
    purrr::map_lgl(ql_names, \(x) avail_calendars[[x]]$financial),
    rep(FALSE, length(ql_names))
  )
})
