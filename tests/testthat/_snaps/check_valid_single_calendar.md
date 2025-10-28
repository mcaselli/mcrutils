# check_valid_single_calendar() works

    Code
      check_valid_single_calendar(123)
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a single character string with the id of a QuantLib calendar.
      x You provided an object of class <numeric> with length 1.
      i See `qlcal::calendars` for valid options.

---

    Code
      check_valid_single_calendar(c("UnitedStates", "Germany"))
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a single character string with the id of a QuantLib calendar.
      x You provided an object of class <character> with length 2.
      i See `qlcal::calendars` for valid options.

---

    Code
      check_valid_single_calendar("InvalidCalendarName")
    Condition
      Error in `check_valid_single_calendar()`:
      ! `calendar` must be a valid QuantLib calendar id.
      x "InvalidCalendarName" is not a recognized QuantLib calendar id.
      i See `qlcal::calendars` for valid options.

