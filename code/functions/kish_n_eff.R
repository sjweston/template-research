# Kish effective sample size for a set of survey weights.
#
# Unequal weights cost precision. The effective n is the size of an
# equally-weighted sample that would give the same standard error, and it is
# what should be read as "how much information is behind this estimate".
#
# w: numeric vector of weights, missing values already removed.

kish_n_eff <- function(w) {
  w <- w[!is.na(w)]
  if (length(w) == 0) {
    return(0)
  }
  sum(w)^2 / sum(w^2)
}
