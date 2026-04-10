#' Integer-preferred breaks function
#'
#' @param n_breaks Approximate number of breaks, passed to
#'   [base::pretty()] as `n`.
#' @param ... Additional arguments passed to [base::pretty()].
#' @return A break function suitable for
#'   [ggplot2::scale_x_continuous()] or [ggplot2::scale_y_continuous()].
#' @keywords internal
#' @noRd
breaks_integer <- function(n_breaks = 5, ...) {
  function(x) {
    breaks <- floor(pretty(x, n_breaks, ...))
    names(breaks) <- attr(breaks, "labels")
    unique(breaks)
  }
}

#' Continuous position scales with integer-friendly breaks
#'
#' `scale_x_integer()` and `scale_y_integer()` are convenience wrappers around
#' [ggplot2::scale_x_continuous()] and [ggplot2::scale_y_continuous()] that
#' prefer clean integer breaks (for example avoiding 2.5-step breaks on ranges
#' around 10).
#'
#' @param n_breaks Approximate number of integer-preferred breaks, passed to
#'   [base::pretty()] as `n`.
#' @param ... Named arguments passed through to [ggplot2::scale_x_continuous()] or [ggplot2::scale_y_continuous()], except `breaks`.
#'
#'   Breaks are generated using `floor(pretty(x, n_breaks))`. If you need to
#'   supply `breaks` directly, use [ggplot2::scale_x_continuous()] or
#'   [ggplot2::scale_y_continuous()] instead.
#'
#' @return A ggplot2 scale object.
#' @rdname scale_integer
#' @export
scale_x_integer <- function(n_breaks = 5, ...) {
  args <- list(...)
  if ("breaks" %in% names(args)) {
    cli::cli_abort(c(
      "{.arg breaks} is not supported by {.fn scale_x_integer}.",
      "i" = "Use {.fn ggplot2::scale_x_continuous} directly if you need more control."
    ))
  }
  args$breaks <- breaks_integer(n_breaks = n_breaks)
  do.call(ggplot2::scale_x_continuous, args)
}


#' @rdname scale_integer
#' @export
scale_y_integer <- function(n_breaks = 5, ...) {
  args <- list(...)
  if ("breaks" %in% names(args)) {
    cli::cli_abort(c(
      "{.arg breaks} is not supported by {.fn scale_y_integer}.",
      "i" = "Use {.fn ggplot2::scale_y_continuous} directly if you need more control."
    ))
  }
  args$breaks <- breaks_integer(n_breaks = n_breaks)
  do.call(ggplot2::scale_y_continuous, args)
}