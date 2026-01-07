test_that("most_recent_sunday() works", {
  expect_equal(as.integer(format(most_recent_sunday(), "%u")), 7) # 7 = Sunday
  expect_equal(most_recent_sunday("2024-06-15"), as.Date("2024-06-09"))
  expect_equal(
    most_recent_sunday(c("2026-01-03", "2026-01-04", "2026-01-05")),
    as.Date(c("2025-12-28", "2026-01-04", "2026-01-04"))
  )
})

test_that("most_recent_monday() works", {
  expect_equal(as.integer(format(most_recent_monday(), "%u")), 1) # 1 = Monday
  expect_equal(most_recent_monday("2024-06-15"), as.Date("2024-06-10"))
  expect_equal(
    most_recent_monday(c("2026-01-04", "2026-01-05", "2026-01-06")),
    as.Date(c("2025-12-29", "2026-01-05", "2026-01-05"))
  )
})
