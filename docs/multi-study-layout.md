# Projects with more than one study

**The default at foundry10 is one repository per study.** Read this before deciding otherwise — the multi-study layout is a real option, but it is the exception.

---

## Why one repository per study is usually right

Two studies that feel like one project rarely stay that way:

- **Timelines diverge.** Study 1 is under review while Study 2 is still collecting. One goes public; the other cannot.
- **Data governance differs.** Different IRB protocols, different consent language, different district agreements. Combining them means the strictest rule governs everything.
- **People differ.** The person who should have access to Study 2 is not necessarily on Study 1.
- **A shared README serves neither.** A reader arriving from a paper about Study 1 has to work out which half of the repository is theirs.

Separate repositories cost you a bit of duplication. Combined repositories cost you flexibility at exactly the moments you need it.

---

## When a single repository is genuinely better

Use the layout below when the studies are **technically entangled**, not merely thematically related:

- Studies drawing on **the same dataset** — waves of one longitudinal study, or several papers from one survey
- Studies sharing a **substantial cleaning pipeline**, where a fix to the cleaning code must apply to all of them at once
- A **pilot and a main study** where the pilot's only purpose was to inform the main study and neither will be published separately

The test: **would a change to the cleaning code need to apply to both studies simultaneously?** If yes, one repository. If not, two.

---

## The layout

Each study gets a complete, self-contained copy of the standard structure. Only genuinely shared things live at the root.

```
project-name/
├── README.md                  Describes the project; links to each study
├── CONVENTIONS.md
├── SETUP.md
│
├── shared/                    ONLY things used by more than one study
│   ├── code/
│   │   ├── 00_setup.R            Paths, packages, seed — used by all studies
│   │   └── functions/            Functions used by more than one study
│   └── data/
│       ├── raw/                  The shared source data
│       └── processed/
│
├── studies/
│   ├── 01-pilot/
│   │   ├── README.md             This study specifically
│   │   ├── code/
│   │   │   ├── 01_clean.R
│   │   │   ├── 02_analyze.R
│   │   │   └── run_all.R
│   │   ├── data/processed/       Study-specific derived data
│   │   ├── output/
│   │   │   ├── figures/
│   │   │   └── tables/
│   │   └── docs/decisions.md     Decisions for THIS study
│   │
│   └── 02-main/
│       └── ... same structure ...
│
├── materials/                 Instruments, organized by study
└── docs/                      Project-level docs
```

---

## Rules that keep this from becoming a mess

**Studies are self-contained.** A study folder holds everything specific to that study. Someone should be able to read `studies/02-main/` and understand that study without reading the other one.

**`shared/` is for things used by more than one study — nothing else.** The failure mode is `shared/` slowly absorbing everything until each study folder holds a single script and no one can tell what belongs to what. If only one study uses it, it lives in that study.

**Never split a single study across the top level.** Do not create `data/study1/` and `code/study1/` and `output/study1/`. That scatters one study across the whole tree and forces anyone reading it to hold three locations in their head at once. Component-inside-study, not study-inside-component.

**Number and name the studies** — `01-pilot`, `02-main`, `03-replication`. Numbers preserve order; names say what they are.

**Each study gets its own decisions log.** Analytic choices are per study.

**Each study gets its own README**, with its own IRB number, preregistration link, and status.

---

## Setting it up

1. Create the repository from the template as normal
2. Create `shared/` and `studies/`
3. Move `code/00_setup.R` and `code/functions/` into `shared/code/`
4. Create the first study folder and move the numbered scripts into it
5. Update the paths in `shared/code/00_setup.R` — it needs to know which study is running. A simple approach is a variable at the top of each study's `run_all.R`:
   ```r
   study <- "02-main"
   source(here::here("shared", "code", "00_setup.R"))

   path_output <- here("studies", study, "output")
   ```

6. Update the root `README.md` to list the studies and link to each

---

## The escape hatch

If a study outgrows the arrangement — it gets its own funding, its own team, or needs to go public on its own timeline — split it into its own repository. That is a normal thing to do and not an admission that the original decision was wrong. Copy the study folder into a fresh repository from the template, and note the split in both READMEs so the connection is not lost.
