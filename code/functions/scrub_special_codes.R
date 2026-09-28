# =============================================================================
# scrub_special_codes()
#
# Sets to NA exactly the cells recorded by find_special_codes().
# =============================================================================

#' Blank the cells listed in a special-code ledger
#'
#' This takes the ledger rather than working out for itself which cells are
#' special. That is deliberate: if the ledger and the scrub each derived their
#' own answer, the two could disagree -- we would report having scrubbed one
#' set of participants and actually have scrubbed another, with nothing to
#' flag it. Feeding one into the other makes them the same set by construction.
#'
#' @param data Data frame to scrub.
#' @param ledger Output of find_special_codes().
#' @param id_col Name of the participant identifier column, in both.
#' @return `data`, with the listed cells set to NA. Value labels are kept, so
#'   the codebook can still be built afterwards.

scrub_special_codes <- function(data, ledger, id_col = "id") {
  stopifnot(id_col %in% names(data), id_col %in% names(ledger))

  for (variable in unique(ledger$variable)) {
    ids <- ledger[[id_col]][ledger$variable == variable]
    data[[variable]][data[[id_col]] %in% ids] <- NA
  }

  data
}
