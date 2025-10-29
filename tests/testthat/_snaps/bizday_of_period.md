# a period starting on a weekend warns

    Code
      bizday_of_period(seq(as.Date("2023-04-01"), by = "day", length.out = 4),
      "UnitedStates", period = "month")
    Condition
      Warning:
      ! Dates 2023-04-01 and 2023-04-02 are non-working days in the "UnitedStates" calendar.
      i Business day of period can be misleading when run on unadjusted non-working days.
      i Consider adjusting the input dates before calculating business day of period. (See `qlcal::adjust()` or `bizdays::adjust.date()`)
    Output
      [1] 0 0 1 2

# bizday_of_period() errors on bad calendar

    Code
      bizday_of_period(as.Date("2023-06-15"), "NonExistentCalendar", period = "month")
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a valid QuantLib calendar id.
      x "NonExistentCalendar" is not a recognized QuantLib calendar id.
      i See `qlcal::calendars` for valid options.

