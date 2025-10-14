# mcrutils 0.0.0.9006

## New

-   `plot_accounts_by_status()` can now display lost accounts in two
    ways. Default behavior `lost = "detailed"` shows temporarily_lost
    and termially_lost separately (as in prior versions), while
    `lost = "simple"` combines them into a single lost category.

## Changed

-   `auto_dt()` now includes copy and download buttons by default. Set
    `buttons = FALSE` to suppress
