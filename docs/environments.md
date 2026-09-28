# Controlling your R environment: `rig` and `renv`

A practical guide to pinning down *which R* and *which packages* your analysis ran on.

This is optional. Read the first section before deciding whether you need it.
---

## Do you actually need this?

Be honest about which project you have. The overhead is real, and applying it
to a two-week descriptive analysis is a bad trade.

| Your project | What to use |
|---|---|
| Short descriptive analysis, done in a month, unlikely to be revisited | Nothing. `docs/session-info.txt` is already written by `03_analyze.R`. |
| Will be revisited, or has several collaborators | A dated repository (one line — see below) |
| Preregistered, published, or externally audited | `renv` |
| Needs a specific R version, or you juggle several projects | `rig`, alongside either of the above |

**The two tools do different jobs and are not alternatives:**

- **`rig`** manages **R itself** — which version of R you are running
- **`renv`** manages **packages** — which versions of dplyr, lme4, and so on

`renv` alone will not save you if a collaborator is on R 4.2 and you are on R 4.6. `rig` alone will not save you if `dplyr` changed a default between versions. For most projects, packages matter more than R itself.

---

## The cheapest option: a dated repository

Before reaching for `renv`, know that one line in `code/00_setup.R` gets you a surprising amount:

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/2026-09-01"))
```

That points R at Posit Public Package Manager's snapshot of CRAN **as it was on that date**. Anyone who installs packages afterwards gets the versions current on 1 September 2026, not whatever is newest today.

**What it gives you:** consistent versions for anyone setting up the project from scratch, at essentially zero cost, with pre-built binaries so installs are fast.

**What it does not give you:** it does not change packages you already have installed, and it does not record what you actually used.

Two details worth knowing: snapshots are taken on business days only (a weekend date resolves to the nearest earlier snapshot), and Package Manager keeps roughly four years of history and binaries for the five most recent R versions. For an analysis you expect someone to reproduce in 2035, that is not enough on its own — use `renv`.

---

# Part 1: `rig` — managing R versions

## Why

Installing a new R version normally overwrites the old one, which means upgrading R can silently change results in a project you are mid-way through. `rig` lets several versions coexist so you can upgrade without gambling.

## Install

**macOS:**

```bash
brew tap r-lib/rig && brew install --cask rig
```

**Windows:** download the installer from <https://github.com/r-lib/rig/releases>

## The commands you will actually use

```bash
rig list                  # which R versions do I have?
rig add release           # install the current release
rig add 4.4.2             # install a specific version
rig default 4.6.1         # set the version used by default
rig rstudio 4.4.2         # launch RStudio against a specific version
rig rm 4.3.1              # remove one
```

## Two things to know

**Patch versions collide.** You can have 4.5.2 and 4.6.0 side by side, but not 4.6.0 and 4.6.1 — same major.minor versions overwrite each other. In practice this is fine; pinning to the minor version is usually enough.

**Packages are per-version.** Installing R 4.6 does not carry your library over from 4.5. This is correct behavior — packages are compiled against a specific R version — but it surprises people. It is also the strongest argument for using `renv` alongside it, since `renv::restore()` rebuilds the library for you.

---

# Part 2: `renv` — managing packages

## The mental model

`renv` gives your project its **own package library**, separate from your system library, plus a **lockfile** (`renv.lock`) recording exactly which versions are in it.

Three verbs:

| Command | What it does |
|---|---|
| `renv::init()` | Set up renv for this project. Once, at the start. |
| `renv::snapshot()` | Record what is currently installed into `renv.lock` |
| `renv::restore()` | Install exactly what `renv.lock` says |

Think of `snapshot()` as "save my environment" and `restore()` as "give me someone else's environment."

## Setting it up

In your project, with the `.Rproj` open:

```r
install.packages("renv")
renv::init()
```

renv scans your code for `library()` calls, installs those packages into a project-local library, and writes `renv.lock`. Restart R when it asks.

Then commit:

```
renv.lock          <- YES, commit this. It IS the record.
renv/activate.R    <- YES, commit this.
.Rprofile          <- YES, commit this.
renv/library/      <- NO. Already ignored by this template's .gitignore.
```

The library folder is hundreds of megabytes of machine-specific compiled code. The lockfile is a small text file. Only the lockfile belongs in Git.

## The daily loop

```r
install.packages("lme4")   # add a package as usual
renv::snapshot()           # record it in the lockfile
```

Then commit `renv.lock` along with your code. Run `renv::status()` any time to see whether your library and lockfile agree.

## What a collaborator does

```r
renv::restore()
```

---

## Frustrating things


### "It compiled for forty minutes and then failed"

**This used to be the biggest problem with renv, and current versions largely fix it.** New renv projects now use Posit Public Package Manager by default (`renv.config.ppm.default` is `TRUE`), which serves **pre-built binaries** — so installs are fast and do not need a compiler.

If you are on an older project set up before this default, point it at P3M:

```r
options(repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"))
renv::snapshot()
```

No extra configuration is needed on macOS or Windows. On Linux you need a platform-specific URL (for example `.../cran/__linux__/jammy/latest`) and the `HTTPUserAgent` option set — RStudio sets it for you, but a plain `Rscript` session does not.

If a package still insists on compiling, you are missing build tools: Xcode command line tools on macOS (`xcode-select --install`), Rtools on Windows.

### "`snapshot()` didn't record a package I'm using"

renv finds dependencies by **reading your code** for `library()` and `::` calls. A package you loaded interactively in the console but never referenced in a script is invisible to it.

Fix: make sure every package your analysis needs is loaded in `code/00_setup.R` or the script that uses it. This is good practice anyway — it is what makes a script runnable start to finish.

To force a package in regardless:

```r
renv::record("somepackage")
```

### "The project won't open properly now"

renv adds a `.Rprofile` that runs `renv/activate.R` at startup. When something goes wrong there, the project fails to load and the message is cryptic.

Recovery: open R with the profile skipped and repair from inside.

```bash
R --vanilla
```

```r
renv::activate()     # or renv::deactivate() to back out entirely
```

`renv::deactivate()` is a complete exit — it stops renv managing the project without deleting `renv.lock`, so nothing is lost and you can re-activate later.

### "Which library am I even using?"

```r
.libPaths()          # first entry should be renv/library/... inside the project
renv::status()       # do library and lockfile agree?
```

### "renv restored, but results still differ"

renv pins packages, not R itself, and not system libraries. If results differ after a clean restore, compare R versions first — that is what `rig` is for — then check `docs/session-info.txt` from the original run.

---

## An alternative worth knowing: `groundhog`

If `renv` feels heavier than your project deserves, `groundhog` takes a different approach — no lockfile, no project library, no activation. You change how you load packages:

```r
library(groundhog)
groundhog.library("tidyverse", "2026-09-01")
```

That loads the version of tidyverse current on that date, installing it if needed. The reproducibility claim is just a date, which is easy to explain in a methods section.

**Trade-offs:** the first run is slow while it fetches older versions, and it still does not pin R itself. But there is nothing to maintain and nothing to break at startup — which for a researcher who has been burned by renv is a real advantage. It was written by researchers for exactly this problem.

---

## Recommendation

1. **Start with nothing.** `docs/session-info.txt` is already being written.
2. **Add the dated repository line** when the project will outlive the semester.
3. **Add `renv`** when the work is preregistered, published, or auditable — and verify `renv::restore()` actually works on someone else's machine *before* you need it to.
4. **Add `rig`** if you juggle projects with different R versions, or if you want to upgrade R without disturbing work in progress.

Whatever you choose, record the choice in `README.md` so a collaborator knows what to do — a `renv.lock` nobody mentions is a file people delete.
