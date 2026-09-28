# =============================================================================
# 03_analyze.R
#
# Runs the analyses and writes figures and tables to output/.
#
# Input:  data/processed/derived.rds
# Output: output/figures/, output/tables/
# =============================================================================

source(here::here("code", "00_setup.R"))

dat <- readRDS(file.path(path_processed, "derived.rds"))


# --- Descriptives ------------------------------------------------------------

# descriptives <- dat |>
#   summarize(
#     n         = n(),
#     mean_age  = mean(age, na.rm = TRUE),
#     sd_age    = sd(age, na.rm = TRUE)
#   ) |>
#   # Round here, not via options(digits) -- that affects printing, not files.
#   mutate(across(where(is.numeric), \(x) round(x, 2)))
#
# write_csv(descriptives, file.path(path_tables, "table1_descriptives.csv"))


# --- Primary analysis --------------------------------------------------------
# If your study is preregistered, say so and link the hypothesis. If an
# analysis was not preregistered, label it exploratory -- here, in the code,
# not only in the write-up.

# H1 (preregistered): [state the hypothesis]
# model_h1 <- lm(outcome ~ condition + covariate, data = dat)
# summary(model_h1)


# --- Figures -----------------------------------------------------------------
# Save figures from code. Never export by clicking, and never hand-edit a
# figure in another program -- the next person to run this script would
# silently lose your changes.

# p1 <- ggplot(dat, aes(x = condition, y = outcome)) +
#   geom_boxplot() +
#   labs(x = "Condition", y = "Outcome", title = NULL) +
#   theme_minimal()
#
# ggsave(
#   file.path(path_figures, "fig1_outcome_by_condition.png"),
#   plot = p1, width = 6, height = 4, dpi = 300
# )


# --- Record the environment --------------------------------------------------
# Which package versions produced these results. Worth its weight in gold when
# a result changes two years from now and nobody knows why.
#
# This writes to docs/ rather than output/ because output/ is not tracked by
# Git -- see output/README.md. Package versions contain no data and are worth
# keeping in the repository permanently.

writeLines(
  capture.output(sessionInfo()),
  here("docs", "session-info.txt")
)
