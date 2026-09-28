# =============================================================================
# run_all.R
#
# Reproduces the entire project from raw data to final output.
#
# Someone who has this repository and access to the data should be able to open
# the .Rproj file, run this one script, and get every result. If that is not
# true, the project is not reproducible -- and the fix belongs in the scripts,
# not in a set of instructions someone has to follow by hand.
#
# Run it periodically, not just at the end. The longer you wait to find out
# that step 3 depends on something you deleted, the more painful it is.
# =============================================================================

source(here::here("code", "00_setup.R"))

source(here("code", "01_clean.R"))
source(here("code", "02_derive.R"))
source(here("code", "03_analyze.R"))
source(here("code", "04_report.R"))

message(
  "\n--- Pipeline complete: ",
  format(Sys.time(), "%Y-%m-%d %H:%M"),
  " ---"
)
