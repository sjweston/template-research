# =============================================================================
# find_special_codes()
#
# Builds the record of which participants had a special missing code scrubbed,
# and which code it was. Pairs with scrub_special_codes(), which consumes the
# ledger this returns.
# =============================================================================

#' Locate every cell holding a special missing code
#'
#' Survey files often store skip, don't-know, and refused responses as
#' numeric codes inside otherwise substantive scales. Left alone, such a code
#' is read as a scale score and a mean becomes meaningless.
#'
#' Matching on value labels rather than on raw numbers is what keeps a real
#' value that happens to equal a code from being deleted. A number counts as a
#' special code only if the column's own value labels say so.
#'
#' Scrubbing the codes is not enough on its own: we also need to be able to
#' say which participants were scrubbed, so that we can check later whether
#' participants who skip a lot differ from those who do not. That is what this
#' returns.
#'
#' @param data Data frame of haven-labelled columns, BEFORE any scrubbing.
#' @param codes Named numeric vector of special codes. The names become the
#'   `reason` column, so they should read well in a table. Names may repeat
#'   when a survey uses different codes for the same reason in different
#'   columns.
#' @param id_col Name of the participant identifier column.
#' @return A tibble with one row per scrubbed cell: the id column, `variable`,
#'   `raw_value`, `reason`.

find_special_codes <- function(data, codes, id_col = "id") {
  stopifnot(id_col %in% names(data), !is.null(names(codes)))

  ids <- data[[id_col]]
  found <- list()

  for (variable in names(data)) {
    # A number counts as a special code only if the FILE says so -- that is,
    # the code appears in that column's own value labels. Matching on the bare
    # number instead would catch a real response that happens to equal a code,
    # and an id that happens to equal one, and would delete real data without
    # saying anything.
    labels <- attr(data[[variable]], "labels")
    if (is.null(labels)) next

    for (i in seq_along(codes)) {
      code <- unname(codes[i])
      if (!as.character(code) %in% as.character(unname(labels))) next

      # Compared as text on both sides. Most columns are numeric, but a
      # labelled CHARACTER column can carry numeric codes in its labels too,
      # and comparing a labelled character to a number errors out. Going
      # through as.character() handles both without a special case, and
      # unclass() drops the labelled class so the comparison is on the stored
      # values alone.
      values <- as.character(unclass(data[[variable]]))
      hits <- which(!is.na(values) & values == as.character(code))
      if (length(hits) == 0) next

      found[[length(found) + 1]] <- tibble::tibble(
        !!id_col := ids[hits],
        variable = variable,
        raw_value = code,
        reason = names(codes)[i]
      )
    }
  }

  if (length(found) == 0) {
    return(tibble::tibble(
      !!id_col := ids[0],
      variable = character(),
      raw_value = numeric(),
      reason = character()
    ))
  }

  dplyr::bind_rows(found)
}
