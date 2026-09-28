# Guidance for AI assistants

This file gives context to AI coding assistants (Claude Code, Copilot, Cursor)
working in this repository. Humans are welcome to read it, but
[`CONVENTIONS.md`](CONVENTIONS.md) is the version written for them.

---

## What this repository is

A foundry10 research project. The people working here are researchers — often
with deep methodological expertise and little or no software engineering
background. Optimize for **clarity and reproducibility over cleverness.**

A researcher should be able to read any code you write and understand what it
does without knowing an idiom you introduced.

---

## Hard rules

**Never write data into version control.** No file from `data/` is ever
committed, and `.gitignore` is not to be loosened to allow one. If a task seems
to require committing a data file, stop and ask. Git history is permanent, this
data involves human subjects, and the repository may become public later.

**Never use absolute paths.** Use `here::here("data", "raw", "file.csv")` in R,
`pathlib` with a project-root constant in Python. No `setwd()`, ever.

**Never commit credentials.** API keys and tokens live in `.Renviron` or `.env`
and are read with `Sys.getenv()`.

**Never modify anything in `data/raw/`.** All transformations happen in
`code/01_clean.R` and write to `data/processed/`.

**Never hand-edit files in `output/`.** They are generated. Fix the code that
generates them.

**Never commit anything from `output/`.** It is ignored for a reason: a fitted
model object contains the full model frame, meaning participant-level data. Do
not suggest `git add -f` on a model object, and do not loosen the ignore rule.

**Never print raw or individual-level data in a `reports/` chunk.** Files in
`reports/` are tracked, so anything a chunk prints is committed permanently. No
`head()`, `View()`, `glimpse()`, or `print(dat)` in a report. Report aggregate
counts and model summaries only. Note that `echo: false` hides code, not
output.

---

## Structure

```
code/00_setup.R      Packages, paths, seed. Sourced by every other script.
code/01_clean.R      Raw → processed
code/02_analyze.R    Models, figures, tables
code/run_all.R       Full pipeline
code/functions/      Project functions, auto-sourced by 00_setup.R
data/raw/            Read-only, never tracked
data/processed/      Generated, never tracked
output/              Generated, NOT tracked (model objects contain data)
reports/             Rendered summaries (.qmd -> .md), IS tracked
docs/decisions.md    Log of substantive analytic choices
```

New scripts follow the numbering (`03_`, `04_`) and get added to `run_all.R`. Make sure the order of the scripts makes sense -- it may help to rename scripts as new changes or analyses are implemented. Make sure the names in `run_all.R` match the correct order.

Shared helper functions go in `code/functions/`, one file each.

---

## Style

- Base R and tidyverse are both fine; match whatever the file already uses
- `snake_case` throughout
- Header comment on every script: purpose, inputs, outputs
- Comment the **why**, not the what — the reasoning behind an exclusion, a
  recode, a model choice
- Prefer explicit, readable code over compact code. A researcher debugging this
  at 11pm should not have to unpick a nested pipeline of anonymous functions.
- Add `stopifnot()` checks after cleaning steps so silent data loss fails loudly

---

## Statistical work

**Do not silently change an analytic decision.** Sample definitions, exclusion
criteria, covariate sets, and model specifications are substantive research
choices, not implementation details. If a change would alter any of them,
say so explicitly rather than folding it into a refactor.

**Do not invent numbers.** Never write a plausible-looking result, sample size,
or coefficient into a report, table, or comment. If a value should come
from the data, it comes from running the code.

**Flag, do not fix, apparent statistical errors.** If an analysis looks wrong —
a mis-specified model, a test that does not match the design, a multiple
comparisons problem — describe the concern and let the researcher decide. They
have context about the study design that this repository does not contain.

**Preregistration matters.** If `README.md` links a preregistration, treat
deviations from it as significant. Analyses that were not preregistered should
be labeled exploratory in the code, not just in the write-up.

**Log decisions.** When a substantive analytic choice is made, add an entry to
`docs/decisions.md`.

---

## Privacy

This is research with human participants, frequently young people and schools.

- Never paste raw data, participant responses, or identifiers into a commit
  message, comment, issue, or code example
- Do not construct example data that mimics real participant records
- If you notice something that looks like identifiable information in a tracked
  file, flag it immediately rather than quietly removing it — if it has already
  been committed, deleting it does not remove it from history, and the
  remediation is different (see `docs/before-going-public.md`)
