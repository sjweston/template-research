# =============================================================================
# format_stats.R
#
# Number formatting for reports and tables. Display only -- nothing here touches a
# stored value.
# =============================================================================


# p-values below .001 are reported as "< .001" rather than as a rounded zero,
# which is what round(0.0000009, 3) would print.
fmt_p <- function(p) {
  ifelse(
    is.na(p),
    NA_character_,
    ifelse(
      p < .001,
      "< .001",
      sub("^0", "", formatC(p, format = "f", digits = 3))
    )
  )
}


# "p < .001" rather than "p = < .001".
p_with_operator <- function(label, p) {
  txt <- fmt_p(p)
  if (is.na(p)) {
    return(paste0(label, " = NA"))
  }
  if (p < .001) paste0(label, " < .001") else paste0(label, " = ", txt)
}


# The one-line test result printed on a figure or in a table caption. Both
# p-values appear: the raw value, and the Holm-adjusted value that should drive
# interpretation.
fmt_test <- function(test_name, statistic, df1, df2, p_value, p_holm) {
  if (is.na(p_value)) {
    return("No test -- a cell fell below the reporting threshold")
  }

  df_part <- if (!is.na(df1) && !is.na(df2)) {
    paste0(" (", round(df1), ", ", round(df2), ")")
  } else {
    ""
  }

  paste0(
    test_name,
    df_part,
    " = ",
    format(round(statistic, 2), nsmall = 2),
    ",  ",
    p_with_operator("p", p_value),
    ",  ",
    p_with_operator("Holm p", p_holm)
  )
}


# Proportions print as percentages, means on their original scale. The scale is
# a property of the outcome, so it is passed in rather than guessed.
#
# outcome_type is normally a single value describing a whole column. ifelse()
# returns a result the length of its TEST, so testing on it directly would
# collapse an entire column of estimates to the first one. It is recycled to
# length first for that reason.
fmt_estimate <- function(x, outcome_type, digits = 2) {
  if (length(outcome_type) == 1) {
    outcome_type <- rep(outcome_type, length(x))
  }
  out <- ifelse(
    outcome_type == "proportion",
    paste0(formatC(x * 100, format = "f", digits = 1), "%"),
    formatC(x, format = "f", digits = digits)
  )
  out[is.na(x)] <- NA_character_
  out
}


fmt_ci <- function(lower, upper, outcome_type, digits = 2) {
  out <- paste0(
    "[",
    fmt_estimate(lower, outcome_type, digits),
    ", ",
    fmt_estimate(upper, outcome_type, digits),
    "]"
  )
  out[is.na(lower) | is.na(upper)] <- NA_character_
  out
}
