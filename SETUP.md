# Setup checklist

You have just created a repository from Sara Weston's analysis template. This setup takes about fifteen minutes and only happens once.

If you have never used GitHub before, work through [`docs/github-guide.md`](docs/github-guide.md) first — it covers step 1 in much more detail, with no assumed background.

---

## 1. Create

Either use the green **Use this template** button (not "Fork" — see the guide for why the difference matters), or from a terminal:

```bash
gh repo create foundry10-research/<project-name> --template sjweston/template-research --private --clone
```

- [ ] Named it descriptively and permanently: lowercase, hyphens, no spaces. `teen-media-use-2026`, not `study1` or `Sara's Project`
- [ ] Confirmed visibility is set to **Private**. Every foundry10 research repository starts private. You can make it public later; you cannot un-publish something that has already been seen.
- [ ] Cloned it to your own computer
- [ ] Added collaborators, if any (Settings → Collaborators and teams)

---

## 2. Make it yours

- [ ] Renamed `template.Rproj` to `[your-project-name].Rproj`
- [ ] Filled in the study information table in [`README.md`](README.md), and the `[PROJECT NAME]` in the reproduction steps
- [ ] Deleted the grey "This is Sara Weston's analysis template" box at the top of `README.md`
- [ ] Replaced the project description at the top of `README.md`
- [ ] Filled in the Google Drive link and access contact in [`data/README.md`](data/README.md)
- [ ] Updated the project, author, and date headers in `code/00_setup.R`
- [ ] Changed the seed in `code/00_setup.R` to today's date
- [ ] Filled in `[YEAR]` and the author names in [`LICENSE`](LICENSE)
- [ ] Filled in the title and author in `reports/summary.qmd`, or deleted it (and `code/04_report.R`) if you will not be writing reports
- [ ] Deleted any folder you genuinely will not use. Do not delete `data/` or its `.gitignore` protection.
- [ ] Created the vault project note at `~/Documents/notebook/projects/<project name>.md` with the frontmatter below. The `repo:` key is how the daily-wrap-up skill finds the project; without it the skill reports `PROJECT: UNRESOLVED`.

  ```yaml
  ---
  type: project
  status: active
  created: YYYY-MM-DD
  PI: "[[Name]]"
  collaborators:
    - "[[Name]]"
  role: Analyst
  repo: ~/Documents/GitHub/<project-name>
  repo_url: https://github.com/foundry10-research/<project-name>
  tags:
    - project
  ---
  ```

- [ ] Confirmed `~/.Renviron` holds every variable listed in [`.Renviron.example`](.Renviron.example) that the project will use
- [ ] If the project needs Python, created the environment with `python -m venv .venv && .venv/bin/pip install -r requirements.txt`. For a Python `.env` file, copy `env.example` to `.env`.

---

## 3. Check that data protection works

Worth two minutes now, because the failure mode is unrecoverable later.

- [ ] Put a test file in `data/raw/` — any CSV will do
- [ ] Open GitHub Desktop and confirm **it does not appear** in the list of
      changes

If it does appear, stop and ask for help before committing anything. Something about the `.gitignore` is wrong and fixing it now takes a minute; fixing it after the file is in the repository's history takes an administrator.

- [ ] Deleted the test file

---

## 4. First commit

- [ ] Made your first commit with a message like `Set up repository from template`
- [ ] Pushed
- [ ] Refreshed the repository on github.com and confirmed your changes are there

---

## 5. Before you start analyzing

- [ ] Skimmed [`CONVENTIONS.md`](CONVENTIONS.md) — it is short, and it is the difference between a repository someone can pick up in a year and one nobody can
- [ ] Opened [`docs/decisions.md`](docs/decisions.md) and made your first entry, even if it is just the date you started
- [ ] Wrote the first `docs/orientation.md` by hand, or ran the daily-wrap-up skill at the end of day one

---

## Multiple studies in one project?

The default at foundry10 is **one repository per study**. Separate studies usually have separate data, separate timelines, and separate decisions about going public, and one repository per study keeps those from tangling.

If your studies genuinely share a dataset or a pipeline, see [`docs/multi-study-layout.md`](docs/multi-study-layout.md).

---

## When the project ends

Do not skip this. See [`docs/project-closeout.md`](docs/project-closeout.md) — archiving the data without recording where it went is the most common way a finished project becomes unreproducible.

---

**Delete this file once you have worked through it.** It is instructions for setting up, not documentation of your project.
