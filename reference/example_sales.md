# Example sales data

A dataset containing example sales data over the time period
"2022-01-01" to "2024-12-20". This is fictitious data created for
demonstration purposes, and it includes several cohorts of
customers–some that are persistent, some that join and leave at various
times.

## Usage

``` r
example_sales
```

## Format

A data frame with 5300 rows and 2 variables:

- account_id:

  Character. A unique identifier for the customer that placed the order.

- market:

  Character. The market where the order was placed; either "United
  States" or "Germany"

- order_date:

  Date. The date of the order.

- units_ordered:

  Integer. The number of units ordered in that order.

## Source

Generated using random sampling for demonstration purposes.
