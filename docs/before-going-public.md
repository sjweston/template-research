# Before making this repository public

Work through this checklist and get approval before changing visibility.

Making a repository public is not reversible in any meaningful sense. Search engines index public repositories within hours, GitHub's own API exposes them immediately, and several services continuously archive public code. A repository that is public for one hour may be permanently mirrored somewhere you cannot reach or request deletion from.

The care is worth it. Public code is good for the field, good for citation, and increasingly required by journals and funders. It just has to be deliberate.

---

## The thing most people get wrong

**Making a repository public exposes its entire history, not just its current state.**

If a data file was committed in March and deleted in April, it is still in the history. Anyone can retrieve it with one command. The file list you see today tells you nothing about what has been committed at some point in the past.

This is why the checks below look at history, not just at the current files.

---

## Approval

Making a foundry10 research repository public requires sign-off from:

- **The research admin** (currently Amy Ly)
- **The director of the research pillar** (currently Dominic Gibson)

Send them a link to the repository and confirmation that you have completed this checklist.

---

## 1. Check the history for data

Ask someone comfortable with the command line to run this from inside the repository:

```bash
git log --all --pretty=format: --name-only --diff-filter=A | sort -u
```

That lists **every file ever added** to the repository, including files that have since been deleted. Read the whole list.

Look for anything that is or contains data: `.csv`, `.xlsx`, `.sav`, `.dta`, `.rds`, `.RData`, and any file whose name suggests participant records.

Pay particular attention to **saved model objects** — a file like `model_h1.rds` reads as a result, but a fitted `lm()` object contains the full model frame, meaning every row of data that went into it. These are ignored by default, so one appearing in the history means someone force-added it.

- [ ] Every file in that list is accounted for and safe to be public

**If you find something:** stop, and contact the research admin before doing anything else. Do not delete the file and assume that resolves it — deleting does not remove it from history. Cleaning history requires rewriting the repository, and it must be coordinated with everyone who has a copy.

---

## 2. Check for credentials

```bash
git log --all -p -S "api_key" | head -50
git log --all -p -S "password" | head -50
git log --all -p -S "token" | head -50
```

- [ ] No API keys, tokens, passwords, or connection strings appear anywhere in the history

**If you find one:** treat it as compromised regardless of what you do next, and rotate it. Assume any credential that was ever committed has been seen.

---

## 3. Read what is actually in the repository now

Do not skim. Open the files.

- [ ] **`output/`** — normally empty in the repository, since its contents are not tracked. If anyone force-added a figure or table with `git add -f`, check it now: no plot should show individual-level data in a way that could identify a participant. A scatterplot of every case in a study of four classrooms is more revealing than it looks.
- [ ] **`materials/`** — no pilot participant names, no internal scoring keys, no direct contact details for district or school staff
- [ ] **`docs/`** — the codebook does not include example rows of real data; the decisions log does not name individual participants
- [ ] **`reports/`** — read the rendered files, not just the `.qmd` sources. No chunk printed raw data, no table has one row per participant, and no cross-tab has cells small enough to identify someone.
- [ ] **Code comments** — no participant identifiers, no `# ask Jamie about the weird case at row 47`, no notes about individual people
- [ ] **Commit messages** — read the full history (`git log --oneline`). Messages are public too, and they get less scrutiny than files.
- [ ] **`data/README.md`** — the Google Drive link is replaced with the Forge archive reference. A link is not access, but it does advertise that the dataset exists and who to approach about it.

---

## 4. Confirm you are permitted to publish

- [ ] The IRB protocol permits public release of what is in this repository
- [ ] Any data use agreement with a district or partner permits it
- [ ] Co-authors and the PI have agreed
- [ ] Any partner organization named in the materials has agreed

---

## 5. Make it useful to a stranger

Someone landing here from a paper should be able to understand the project without you.

- [ ] `README.md` describes the study in plain language
- [ ] The reproduction steps are accurate — follow them yourself, from a fresh clone, and confirm they work
- [ ] All `[BRACKETED PLACEHOLDERS]` are filled in
- [ ] `SETUP.md` is deleted (it is instructions for you, not documentation)
- [ ] `LICENSE` has the correct year and authors
- [ ] `data/README.md` explains how a legitimate researcher can request access
- [ ] `docs/decisions.md` is current

---

## 6. Make it citable

- [ ] Added a `CITATION.cff` file so GitHub displays a "Cite this repository" button
- [ ] Linked the repository to [Zenodo](https://zenodo.org) to mint a DOI, if the work should be formally citable
- [ ] Cross-linked with the OSF project, if there is one
- [ ] Added the repository URL to the write-up

---

## 7. Flip the switch

Settings → scroll to **Danger Zone** → **Change repository visibility** → Make public.

- [ ] Done
- [ ] Opened the repository in a private browser window while signed out, to confirm what the world actually sees
- [ ] Told your co-authors

---

## Afterward

Public does not mean unmaintained. If a reader opens an issue asking how to run something, that is a citation waiting to happen — answer it.

If you later discover something that should not have been published, contact the research admin immediately. Speed matters: the window before something is mirrored is short, but it is not zero.
