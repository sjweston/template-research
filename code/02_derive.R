# =============================================================================
# 02_derive.R
#
# Builds the variables the analysis uses: reverse-coded items, scale scores,
# composites, recodes, and analytic flags. Cleaning (01_clean.R) decides who is
# in the sample; this script decides what is measured.
#
# Input:  data/processed/analysis_sample.rds
# Output: data/processed/derived.rds, output/tables/scale_reliability.csv
#
# The output is a separate file from the input. Deriving is not idempotent (a
# reverse-coded item would be reversed again on a second pass), so every run
# starts from analysis_sample.rds.
# =============================================================================

source(here::here("code", "00_setup.R"))

dat <- readRDS(file.path(path_processed, "analysis_sample.rds"))
n_start <- nrow(dat)
names_start <- names(dat)


# --- Reverse-code and score scales -------------------------------------------
# Reverse first, then score, so describe_scale() sees every item keyed in the
# same direction. Replace the names below with the project's items.

# scale_max <- 5
# dat <- dat |>
#   mutate(across(c(item2, item5), \(x) scale_max + 1 - x, .names = "{.col}_r"))
#
# scales <- list(
#   scale_a = c("item1", "item2_r", "item3"),
#   scale_b = c("item4", "item5_r", "item6")
# )
#
# for (scale_name in names(scales)) {
#   dat[[scale_name]] <- rowMeans(dat[scales[[scale_name]]], na.rm = FALSE)
# }
#
# reliability <- purrr::imap(
#   scales,
#   \(items, scale_name) describe_scale(dat, items, scale_name)
# ) |>
#   bind_rows() |>
#   mutate(across(where(is.numeric), \(x) round(x, 2)))
#
# write_csv(reliability, file.path(path_tables, "scale_reliability.csv"))


# --- Recodes and analytic flags ----------------------------------------------
# One block per variable, with the coding rule stated in a comment above it.

# dat <- dat |>
#   mutate(
#     group = factor(group, levels = c("control", "treatment")),
#     analytic_flag = !is.na(scale_a) & !is.na(group)
#   )


# --- Check your work ---------------------------------------------------------
# If an earlier step changes, these stop the file.

stopifnot(nrow(dat) == n_start)

for (variable in setdiff(names(dat), names_start)) {
  stopifnot(!all(is.na(dat[[variable]])))
}


# --- Save --------------------------------------------------------------------

saveRDS(dat, file.path(path_processed, "derived.rds"))
