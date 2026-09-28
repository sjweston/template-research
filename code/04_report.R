# =============================================================================
# 04_report.R
#
# Renders reports/summary.qmd.
#
# The .qmd lives in reports/ and is tracked, so the document is reproducible
# from code. A rendered PDF or HTML file changes wholesale on every render, so
# it is moved to output/reports/, which is not tracked, and shared from there
# directly. A gfm report is plain Markdown that diffs cleanly, so it stays in
# reports/.
#
# Input:  data/processed/derived.rds, reports/summary.qmd
# Output: reports/summary.md (gfm) or output/reports/summary.<format>
# =============================================================================

source(here::here("code", "00_setup.R"))

# Must match the format set in the YAML header of summary.qmd.
report_format <- "gfm"

dir.create(path_reports, recursive = TRUE, showWarnings = FALSE)

quarto::quarto_render(here("reports", "summary.qmd"), quiet = FALSE)

if (report_format %in% c("pdf", "html")) {
  rendered <- here("reports", paste0("summary.", report_format))
  stopifnot(file.exists(rendered))
  file.rename(
    rendered,
    file.path(path_reports, paste0("summary.", report_format))
  )
}

# To add a second report, render it the same way:
# quarto::quarto_render(here("reports", "data_quality.qmd"), quiet = FALSE)
