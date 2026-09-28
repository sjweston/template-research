# Reports

Rendered summaries of the analysis, written to be **read** rather than run.

This is the folder for a collaborator, a PI, or a partner who wants to see what
you found without installing R and executing your pipeline.

Unlike `output/`, **the contents of this folder are tracked by Git.** That is
the entire point: a report nobody can open without cloning and running code is
not solving the problem it exists to solve.

---

## The safety rule, stated plainly

`output/` is untracked because a saved model object silently contains the data
it was fit on. A report is different — you choose what goes into it — but that
is a responsibility, not a guarantee.

**A rendered report contains whatever your code chunks printed.**

One `head(dat)` left in a chunk while you were debugging puts six rows of
participant data into a tracked file, permanently, in something that looks like
a summary document. This is a realistic way to leak data, and it is easy to do
by accident.

So, before committing a report:

- [ ] No chunk prints raw or individual-level data — no `head()`, no `View()`,
      no `print(dat)`, no `glimpse()` left over from debugging
- [ ] No table has one row per participant
- [ ] Cell sizes are large enough that nobody is identifiable. A cross-tab with
      a single participant in a cell identifies that person to anyone who knows
      the study.
- [ ] **Read the rendered file itself**, not just the source. What renders is
      what gets committed, and the two are easy to conflate.

Setting `echo: false` in the YAML header hides your code but **does not hide
its output**. It is a formatting choice, not a safety feature.

---

## Format: use `gfm`

Quarto can render to many formats. For this purpose the choice matters more
than it looks:

| Format | Renders on github.com? | Notes |
|---|---|---|
| **`gfm`** (GitHub markdown) | **Yes, natively** | Best default. Also diffs as plain text, so you can see what changed between versions. |
| `pdf` | Yes, inline viewer | Good for emailing or attaching to a write-up. Requires a LaTeX install (`tinytex::install_tinytex()`). |
| `html` | **No** | GitHub shows the raw source, not the page. Fine locally, useless to the colleague you are trying to reach. |

Unless you have a reason to do otherwise, render to `gfm`. Someone can then
click the file on GitHub and simply read it, which is the whole goal.

A `gfm` report writes its figures into a folder next to it — for `summary.qmd`,
that is `summary_files/`. The `.gitignore` is set up to track those, so images
display correctly on GitHub. Commit that folder along with the report.

---

## Suggested contents

```
reports/
├── summary.qmd          Source — the file you edit
├── summary.md           Rendered — the file people read
└── summary_files/       Figures for the rendered version
```

Common reports worth writing:

- **Analysis summary** — the main findings, for the PI and co-authors
- **Data quality report** — sample sizes, missingness, attrition by wave.
  Useful early and often, and it surfaces problems while there is still time
  to do something about them.
- **Partner-facing summary** — findings for a school or district, in plain
  language, with the methodological caveats a research audience would assume
  but a practitioner audience would not

---

## Rendering

In RStudio, open the `.qmd` and click **Render**. Or from R:

```r
quarto::quarto_render(here::here("reports", "summary.qmd"))
```

Reports read from `data/processed/`, so run `code/run_all.R` first if the
cleaning has changed.

**Re-render before committing.** A report showing numbers from an analysis you
have since revised is worse than no report at all — it looks current, and
people will quote it.

---

## What does not go here

- **Write-ups for publication.** Those live in Google Docs or Word, outside
  this repository.
- **Raw model output.** Dumping `summary(model)` into a document is not a
  report. Report the numbers a reader needs, in a table.
- **Anything with participant-level rows.** See the checklist above.
