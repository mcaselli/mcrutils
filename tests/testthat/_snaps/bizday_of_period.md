# a period starting on a weekend warns

    Code
      bizday_of_period(seq(as.Date("2023-04-01"), by = "day", length.out = 4),
      "UnitedStates", period = "month")
    Condition
      Warning:
      ! Dates 2023-04-01 and 2023-04-02 are non-working days in the "UnitedStates" calendar.
      i Business day of period can be misleading when run on unadjusted non-working days.
      i Consider adjusting the input dates before calculating business day of period. (See `qlcal::adjust()` or `bizdays::adjust.date()`
    Output
      [1] 0 0 1 2

