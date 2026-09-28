# =============================================================================
# describe_scale()
#
# One tidy row of reliability information per scale, so the reliability table
# in a report is generated rather than transcribed by hand.
#
# =============================================================================

#' Summarize the internal consistency of a set of scale items
#'
#' Alpha here is UNWEIGHTED. Reliability is a property of the instrument
#' rather than of the population estimate, and an unweighted alpha is what is
#' comparable to the published figures for these scales. If the project's
#' substantive estimates are weighted, this is the exception, and the report
#' should say so.
#'
#' For two-item scales the function returns the correlation and leaves alpha
#' missing. Alpha is unstable at that length and the correlation is the honest
#' summary.
#'
#' @param data A data frame.
#' @param items Character vector of item names.
#' @param scale_name Label for the scale, used in the output table.
#' @return A one-row tibble: scale, n_items, items, n, alpha, mean_r. `items`
#'   is the item names joined with ";", so a display can list what a
#'   composite averages without a second copy of the definition.

describe_scale <- function(data, items, scale_name) {
  stopifnot(all(items %in% names(data)), length(items) >= 2)

  # as.numeric() strips haven's labelled class; without it psych::alpha() and
  # cor() operate on a labelled vector and the results are not trustworthy.
  scored <- as.data.frame(lapply(data[items], as.numeric))
  complete <- stats::complete.cases(scored)
  scored <- scored[complete, , drop = FALSE]

  if (length(items) == 2) {
    return(tibble::tibble(
      scale = scale_name,
      n_items = 2L,
      items = paste(items, collapse = ";"),
      n = nrow(scored),
      alpha = NA_real_,
      mean_r = stats::cor(scored[[1]], scored[[2]])
    ))
  }

  # psych::alpha() prints warnings about negatively-keyed items directly to the
  # console. We check keying deliberately elsewhere, so quiet it here rather
  # than letting it scroll past every run.
  result <- suppressWarnings(
    psych::alpha(scored, warnings = FALSE, check.keys = FALSE)
  )

  tibble::tibble(
    scale = scale_name,
    n_items = length(items),
    items = paste(items, collapse = ";"),
    n = nrow(scored),
    alpha = result$total$raw_alpha,
    mean_r = result$total$average_r
  )
}
