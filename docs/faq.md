# FAQ

Questions that come up repeatedly, with the reasoning behind the answer.

If you hit something not covered here, ask — and then add it, so the next person does not have to.

**Contents**

- [Why `here()` instead of a plain relative path?](#why-here-instead-of-a-plain-relative-path)
- [Why "Use this template" instead of "Fork"?](#why-use-this-template-instead-of-fork)
- [My data file isn't showing up in GitHub Desktop. Is it broken?](#my-data-file-isnt-showing-up-in-github-desktop-is-it-broken)
- [Can I ever commit a data file?](#can-i-ever-commit-a-data-file)
- [Why is `output/` not tracked but `reports/` is?](#why-is-output-not-tracked-but-reports-is)
- [My collaborator can't see my figures. What do I send them?](#my-collaborator-cant-see-my-figures-what-do-i-send-them)
- [I get "cannot open the connection". What does that mean?](#i-get-cannot-open-the-connection-what-does-that-mean)
- [Repository Settings and organization Settings are different?](#repository-settings-and-organization-settings-are-different)
- [Do I need `renv`?](#do-i-need-renv)
- [One repository or several?](#one-repository-or-several)
- [I committed something I shouldn't have. What now?](#i-committed-something-i-shouldnt-have-what-now)

---

## Why `here()` instead of a plain relative path?

**Short answer:** because a relative path in R is relative to the *working directory*, not to the folder the script lives in.

If `01_clean.R` sits in `code/`, and the data sits in `data/raw/`, surely `read_csv("data/raw/survey.csv")` just works?

It does — as long as the working directory is the project root. **A running R script cannot find out where it lives.** That information is not available to it. So the same line reads from a different place depending on how the session was started.

Here is the same script, same path, run two ways:

```
Run from the project root:      plain relative path OK, rows = 250
Run from inside code/:          Error: cannot open the connection
```

It works when you open the `.Rproj`, so most of the time, it won't be a problem for you. However, the goal is to build in safeguards.

**The two situations where it will bite you:**

1. **Someone opens the script instead of the project.** Double-clicking `01_clean.R` in Finder launches RStudio with the working directory set to their home folder. Every path fails, and the error message says nothing about working directories.

2. **Anything in `reports/` is rendered.** Quarto and R Markdown set the working directory to the *document's* folder — even when you render from the project root. `"data/raw/survey.csv"` then looks for `reports/data/raw/survey.csv` and does not find it.

The template summary file, `reports/summary.qmd`, sources `code/00_setup.R`, which defines `path_raw` and friends. Those paths are used by the scripts (working directory = project root) *and* by the report (working directory = `reports/`). Without `here()`, there is no single correct value — you would need code that detects how it was invoked, which is worse than a small dependency.

**Is `here` strictly necessary?** No. If you always open the `.Rproj`, never call `setwd()`, and have no `.qmd` files, plain relative paths work fine. But the premium is one small package (`here` depends only on `rprojroot`; both are pure R, install in seconds, and never need compiling). What it buys is that the project works when someone does the obvious wrong thing.

---

## Why "Use this template" instead of "Fork"?

Both make a copy, but a fork keeps a permanent link back to the original.

The practical consequence: when you later open a pull request in your own project, GitHub defaults to targeting **the template repository** rather than yours.

"Use this template" gives you an independent repository with a clean history. Save forking for contributing to someone else's public project.

---

## My data file isn't showing up in GitHub Desktop. Is it broken?

No — that is the system working correctly. `.gitignore` deliberately hides everything in `data/` so that research data cannot be committed by accident.

If a data file *does* appear in the Changes list, that is the problem worth asking about. Do not commit it; see the last question on this page.

---

## Can I ever commit a data file?

Occasionally, deliberately, for one file at a time:

```bash
git add -f data/processed/analysis_sample.csv
```

This is reasonable for a small, **fully de-identified** analytic file that makes your results reproducible without a data request. The full checklist is in [`../data/README.md`](../data/README.md), but the test that matters is: *this file may become public one day — is that fine?*

If you are unsure, ask first.

---

## Why is `output/` not tracked but `reports/` is?

Because of what each one can contain without you noticing.

**`output/` holds generated artifacts, including model objects.** A fitted `lm()` object is not a summary of your data — it *contains* your data, in its `$model` component: every row that went into the fit. Saving one to `output/` and committing it would put participant-level data into permanent history, in a file that looks like a result. Rather than asking everyone to correctly sort safe outputs from unsafe ones every time, nothing in `output/` is tracked.

**`reports/` holds documents you wrote to be read.** You choose what goes in them, so they are tracked — that is the whole point, since a report nobody can open without running R is not solving its problem.

That choice is a responsibility, though. A rendered report contains whatever your chunks printed, so a `head(dat)` left in from debugging puts participant rows into a tracked file. See [`../reports/README.md`](../reports/README.md).

---

## My collaborator can't see my figures. What do I send them?

Since `output/` is not tracked, figures do not appear on GitHub.

**The intended route is `reports/`.** Write up the finding in `reports/summary.qmd`, render it to `gfm`, and commit — your collaborator can then read it directly on github.com with the figure embedded and a sentence explaining what it shows.

For a one-off, use Slack or email. Not everything needs to be in version control.

---

## I get "cannot open the connection". What does that mean?

R could not find a file. Nine times out of ten, on this project, it means the working directory is not what you think it is.

Check:

1. **Did you open the `.Rproj` file, or just the script?** Opening a script directly does not set the working directory. Close RStudio, open the `.Rproj`, and try again.
2. **Run `getwd()`.** It should print the project root. If it prints your home folder or `.../code`, that is the problem.
3. **Is the file actually there?** Data is not in the repository — you have to put it in `data/raw/` yourself. See [`../data/README.md`](../data/README.md).

---

## Repository Settings and organization Settings are different?

- **Repository Settings** — `github.com/foundry10-research/<repo>` → Settings. Controls that one repository: collaborators, branch rules, the template checkbox.
- **Organization Settings** — `github.com/foundry10-research` → Settings. Controls the whole org: member privileges, base permissions, who can create repositories.
  **Only organization owners can see this page.**

If a step tells you to open org settings and there is no Settings tab, you are probably not an owner. Ask the research admin rather than hunting for it.

---

## Do I need `renv`?

Probably not at first, and the template does not require it.

`03_analyze.R` already writes `docs/session-info.txt`, which records the package versions your results were produced with. That is honest and free, but it is a *record*, not a way to recreate the environment — it tells a future reader what you used without helping them get it.

Three steps up the ladder, take them when the project justifies it:

1. **A dated repository.** One line in `code/00_setup.R` pointing at a dated CRAN snapshot, so anyone installing packages gets versions as of that date.
2. **`renv`.** A project-local library plus a lockfile recording exact versions, so a collaborator runs `renv::restore()` and gets what you had. Worth it for preregistered, published, or auditable work.
3. **`rig`.** Manages R versions rather than packages — useful when projects need different R versions, or you want to upgrade R without disturbing work in progress.

If you have tried `renv` before and found it painful, `groundhog` is a much lighter alternative that needs no project setup at all.

Full walkthrough, including the failure modes and how to get out of them: [`environments.md`](environments.md).

---

## One repository or several?

**Default: one repository per study.** Separate studies tend to acquire separate timelines, IRB protocols, and publication decisions, and one repository per study keeps those from tangling.

Use a single multi-study repository only when studies are *technically* entangled — sharing a dataset or a cleaning pipeline. The test: would a change to the cleaning code need to apply to both studies at once?

See [`multi-study-layout.md`](multi-study-layout.md).

---

## I committed something I shouldn't have. What now?

**Stop. Do not push.** If you have already pushed, do not simply delete the file — deleting does not remove it from history, and the file is still recoverable by anyone with the repository.

Contact the research admin (currently Amy Ly) right away. Removing something from Git history requires rewriting the repository, and it has to happen before other people pull.

This applies to data files, participant information, and API keys. For keys, assume the key is compromised and rotate it regardless of what happens next.
