# bizdays_between() errors on bad calendar

    Code
      bizdays_between("2025-07-01", "2025-07-15", "NonExistentCalendar")
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a valid QuantLib calendar id.
      x "NonExistentCalendar" is not a recognized QuantLib calendar id.
      i See `qlcal::calendars` for valid options.

