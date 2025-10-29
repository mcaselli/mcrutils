# is_bizday() errors for invalid calendar

    Code
      is_bizday("2024-07-05", "InvalidCalendar")
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a valid QuantLib calendar id.
      x "InvalidCalendar" is not a recognized QuantLib calendar id.
      i See `qlcal::calendars` for valid options.

