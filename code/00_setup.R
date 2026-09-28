# =============================================================================
# 00_setup.R
#
# Loads packages, sets options, and defines file paths used by every other
# script. Every numbered script starts by sourcing this file, so anything that
# needs to be true project-wide belongs here and nowhere else.
#
# Project: [PROJECT NAME]
# Author:  [YOUR NAME]
# Created: [YYYY-MM-DD]
# =============================================================================

# --- Packages ----------------------------------------------------------------
# Keep this list short and honest: load what you actually use. If you need a
# package in only one script, load it there instead of here.

library(here) # builds file paths from the project root -- see below
library(tidyverse) # dplyr, ggplot2, readr, and friends


# --- Why paths use here() and not "data/raw/survey.csv" ----------------------
#
# In R, a relative path is relative to the WORKING DIRECTORY, not to the folder
# this script lives in -- a running script has no way to find out where it
# lives. So a plain relative path works when you open the .Rproj, and breaks
# when you do not: double-clicking a script in Finder, or rendering anything in
# reports/ (Quarto sets the working directory to the document's own folder).
#
# here() finds the project root by locating the .Rproj file and builds paths
# from there, so they resolve identically however the session was started.
# There should be no setwd() and no absolute paths anywhere in code/.
#
# Longer explanation: docs/faq.md

# --- File paths --------------------------------------------------------------
# Defining these once means you change a location in one place, not thirty.

path_raw <- here("data", "raw")
path_processed <- here("data", "processed")
path_figures <- here("output", "figures")
path_tables <- here("output", "tables")
path_reports <- here("output", "reports")


# --- Reproducibility ---------------------------------------------------------
# Set a seed so that anything random -- bootstrapping, multiple imputation,
# train/test splits, jittered plots, simulations -- produces the same result
# every time this code is run. Without it, your numbers change slightly on
# every run and you cannot tell a real change from noise.

set.seed(20260827) # convention: the date you started the project


# --- Options -----------------------------------------------------------------

# Pin package versions to a date by pointing CRAN at a dated snapshot. See
# docs/environments.md.
# options(repos = c(CRAN = "https://packagemanager.posit.co/cran/YYYY-MM-DD"))

options(
  stringsAsFactors = FALSE,
  scipen = 999, # print 0.00001 instead of 1e-05
  digits = 4 # see the warning below -- this affects PRINTING only
)

# A gotcha worth knowing: options(digits) changes how numbers are DISPLAYED in
# the console. It does not change what gets written to a file. write_csv() will
# happily save 15.506912442396313 to your table regardless of this setting.
#
# If you want rounded numbers in a saved table, round them explicitly:
#
#     mutate(across(where(is.numeric), \(x) round(x, 2)))

# --- Project functions -------------------------------------------------------
# Anything you write yourself and use more than once goes in code/functions/
# as its own file. This loads all of them.

function_files <- list.files(
  here("code", "functions"),
  pattern = "\\.R$",
  full.names = TRUE
)
invisible(lapply(function_files, source))
rm(function_files)


# Every script sources this file, so that each one can be run on its own. That
# means setup runs several times during a full run_all.R -- which is harmless,
# but printing this message three times looks like something went wrong.
if (!exists(".setup_message_shown")) {
  message("Setup complete: ", format(Sys.time(), "%Y-%m-%d %H:%M"))
  .setup_message_shown <- TRUE
}
