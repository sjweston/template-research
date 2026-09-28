# Conventions

How we name things and organize code in foundry10 research repositories.

These are conventions, not rules — nothing here is enforced by software, and nobody will reject your work for breaking one. They exist because each one prevents a specific, common way that research projects become unreadable to their own authors. The examples are in R, but the principles apply equally to Python and Stata.

The underlying idea: **write for the person who opens this repository in two years knowing nothing about it.**

---

## 1. Never use absolute paths

This is the single most common reason someone else cannot run your code.

```r
# Bad
setwd("/Users/sara/Documents/GitHub/teen-media-study")
dat <- read.csv("/Users/sara/Documents/GitHub/teen-media-study/data/raw/survey.csv")

# Good
library(here)
dat <- read.csv(here("data", "raw", "survey.csv"))
```

`here()` finds the project root by locating the `.Rproj` file and builds paths from there. Open the `.Rproj` file to start work, not the individual scripts, and every path resolves correctly.

The equivalents elsewhere: `pyprojroot` or `pathlib` with a project-root constant in Python; a single global set once in a `_config.do` in Stata, since Stata has no built-in equivalent.

This is especially important if more than one researcher is running code -- it will ensure that code does not break across machines and that no one has to manually change code to make it work for them.

Worth knowing *why* `here()` rather than a plain `"data/raw/survey.csv"`: in R
a relative path resolves against the working directory, not against the folder
the script lives in. It works when you open the `.Rproj` and breaks when
someone opens the script directly, or when anything in `reports/` is rendered.
See [`docs/faq.md`](docs/faq.md).

---

## 2. Number your scripts, and give each one job

```
00_setup.R      Packages, paths, seed. Sourced by everything else.
01_clean.R      Raw data → analysis-ready data
02_derive.R     Scale scores, composites, recodes
03_analyze.R    Models, figures, tables
04_report.R     Renders the reports
run_all.R       Runs everything in order
```

The numbers tell a newcomer where to start and in what order to read. Zero-pad them so `10_` sorts after `09_` rather than after `01_`.

A script that cleans data *and* fits models *and* makes figures is hard to re-run when only the figures changed. Split at the natural seams.

---

## 3. One script reproduces everything

Someone with this repository and access to the data should be able to run a single file and get every result. That is what `run_all.R` is for.

Run it periodically rather than only at the end. The longer you wait, the more painful it is to debug.

---

## 4. Raw data is read-only

Never edit anything in `data/raw/`. Every correction, recode, exclusion, and renaming happens in code. Two reasons:

1. Transparency -- every single data decision is out in the open.
2. Documentation -- gives you the ability to explain or justify choices later (during peer review or in conversation with collaborators).

---

## 5. Set a seed

Anything random — bootstrapping, multiple imputation, cross-validation splits, simulations, jittered points in a plot — gives different results on each run unless you fix the seed. Without a seed you cannot tell a real change in your results from noise, which makes it impossible to check whether an edit did what you meant it to.

Two options:
1. Use `set.seed()` right before each function that uses randomization. This adds code, but makes it easier to run smaller sections of code.
2. Set it once in `00_setup.R`. This is cleaner and less work, but make sure you always refer to the final output when writing up results.
---

## 6. Outputs are generated, never hand-edited

Figures come out of `ggsave()` (or something similar if you don't like `ggplot`), tables come out of `write_csv()`. Do not export a plot by clicking, and do not open a table in Excel to fix a column header.

The next run of the pipeline silently overwrites anything you changed by hand, with no indication that your edit ever existed. If a label is wrong, fix it in the code that draws it.

This is also why `output/` is not tracked by Git — everything in it is regenerable, and saved model objects contain the data they were fit on. See [`output/README.md`](output/README.md).

---

## 7. Name files so they sort correctly

- **Lowercase, no spaces.** `survey_wave1.csv`, not `Survey Wave 1.csv`. Spaces break command-line tools and behave differently across operating systems.
- **`snake_case`** for files, variables, and functions. Pick one style and use it everywhere; the specific choice matters far less than the consistency.
- **ISO dates: `YYYY-MM-DD`.** `2026-08-27`, never `8-27-26`. ISO dates sort chronologically when sorted alphabetically, and they are unambiguous to colleagues outside the US, where `03-04-2026` means April 3rd.
- **Zero-padded numbers.** `01`, `02`, … `10`.
- **Describe the content, not the status.** `analysis_final_v3_REAL_final.R` is what version control exists to prevent. You only need to write `analysis.R` and trust GitHub to save the other versions for you.

---

## 8. Comment the why, not the what

```r
# Bad: restates the code
# subtract 1 from grade
grade_centered <- grade - 1

# Good: explains the decision
# Grade is coded 1-12 in the district export but 0-11 in the survey.
# Aligning to the survey coding so the two sources can be merged.
grade_centered <- grade - 1
```

Also, give each script a header saying what it takes in, what it puts out, and who wrote it.

---

## 9. Log analytic decisions as you make them

`docs/decisions.md` holds substantive choices: exclusion criteria and their justification, deviations from preregistration, why one model specification was chosen over another, how an unexpected data problem was handled. Write the entry right when you make the decision.

---

## 10. Commit often, in meaningful chunks

A commit should be one coherent change. "Add attention check exclusion" is a commit. "Work on Tuesday" is three commits wearing a trenchcoat.

Write messages in the imperative — finish the sentence *"This commit will…"*:

```
Good:  Add attention check exclusion to cleaning script
Good:  Fix reversed coding on items 4-7
Good:  Update Figure 2 with revised sample

Poor:  updates
Poor:  asdf
Poor:  fixed stuff (which stuff?)
```

Small, frequent commits are easier to understand later and much easier to undo. Commit at natural stopping points — after a script runs cleanly, before you try something risky.

---

## 11. Never commit secrets

API keys, passwords, tokens, database connection strings. Put them in `.Renviron` or `.env`, both of which are already ignored, and read them with `Sys.getenv("MY_KEY")`.

A committed key is a leaked key even if you delete it in the very next commit, because it remains in the repository's history. Assume any key that has ever been committed must be rotated.

---

## 12. Notebooks need care in Git

If you use Jupyter or R Markdown notebooks, know that Git handles them badly. A `.ipynb` file stores its outputs — including images, as enormous blocks of encoded text — alongside your code. Two people running the same notebook produce completely different files, and the resulting merge conflicts are close to unreadable.

Options, in order of preference:

1. **Write analysis as plain scripts** (`.R`, `.py`) and use a notebook only for the final report.
2. **Clear all outputs before committing.** `nbstripout` automates this.
3. **Use Quarto (`.qmd`) or R Markdown (`.Rmd`)**, which are plain text and diff normally.

---

## 13. Record your environment

Package versions change, and results occasionally change with them. `03_analyze.R` writes `sessionInfo()` to `docs/session-info.txt`, so that a discrepancy two years from now has a starting point.

If you want stronger guarantees there is a ladder: a dated CRAN snapshot (one
line), then `renv` for exact versions, then `rig` if the R version itself
matters. Worth it for work that will be revisited or externally audited;
skippable for a quick descriptive analysis. See
[`docs/environments.md`](docs/environments.md).

---

## A note on judgment

Following every convention on a two-week descriptive analysis is over-engineering. Skipping all of them on a four-year longitudinal study with five collaborators is how projects become unmaintainable.

If you only ever adopt three, make them: **no absolute paths**, **raw data is read-only**, and **one script that reproduces everything**.
