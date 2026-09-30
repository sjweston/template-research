# Instructions for AI assistants: analysis code and results reporting

Lessons from the college-admissions second-stage build (2026-09-29 and
2026-09-30), written as rules for the next project. Each rule names the
mistake it prevents. `CLAUDE.md` holds the hard rules; this file is the
working practice for the modeling and write-up stages.

---

## Code

**Package functions first, custom functions last.** Before writing a helper,
check whether survey, broom, marginaleffects, purrr or tidyr already does it.
A package function has been validated by its maintainers; ours has not. When
the same step repeats across outcomes or predictors, write the repetition as
`purrr::map()` over a specification table, not as a wrapper function. Custom
functions are justified for figures and for reader-facing labels, and they
stay local to the script unless two scripts share them. *Why:* one session
produced nine function files that reimplemented three packages; the package
versions reproduced every number and the files were deleted.

**A refactor is not done until the outputs are compared.** Keep a copy of the
tables before rewriting, then join old to new row by row and report the
largest difference in every column. "Identical to floating point" is a claim
to demonstrate, not to assert. Any row that differs needs a named reason.

**Never change what a reported number means as a side effect of simplifying
the code.** Replacing a quantity derived from an ordinal model with one from a
binary model on a collapsed outcome is an analytic change even if the column
header stays the same. Say so before doing it, and log it. *Why:* a threshold
logistic model quietly replaced the cumulative-logit reading of two outcomes
and was caught only when the researcher asked "did we collapse the bands?"

**Validate a package's uncertainty on unusual model classes.** Before trusting
standard errors from a general-purpose package on a survey ordinal fit or any
other class off its main path, compare them with a short bootstrap. *Why:*
marginaleffects' delta-method standard errors for `svyolr` were an order of
magnitude too large; the point estimates were exact.

**Check analytic samples against the instrument, not just by count.** For
every sample flag, assert in code that it matches the questionnaire's skip
logic: the gated items are answered by nobody outside the gate, the stage
samples partition on the stage item, the block sample is everyone who did not
skip the block. `stopifnot()` makes the check permanent.

**Watch what packages do to ordering and names.** marginaleffects returns
contrasts alphabetically, so factor levels come back out of order and must be
re-sorted by the factor's own level order. In stringr, a bare `|` inside a
pattern is a regex alternation; use `fixed()` for literal separators.

**Sequences of fits run on the same students.** When a model is fitted with
and without a mediator, restrict every step to the complete cases of the
largest model so that a change across steps is a change in the model, not in
who is in it. Say this in the report.

**Every full run before every report.** A development pass with a small
bootstrap is for catching errors; the numbers that reach a document come from
the full run, and the table should say how many replicates stand behind each
interval.

## Plan and code

**Audit coverage in both directions.** Every analysis the plan promises is in
the script, and every analysis in the script is in the plan. Conditional
promises ("only if income effects survive Tier 1") become due the moment the
condition is met; check them after the first run and say which are now owed.

**The plan's own inconsistencies are worth raising.** Gating pairwise
contrasts on an omnibus test and then Holm-correcting them protects twice and
sits oddly beside "raw p, no correction." One rule for every p-value in a
document is easier to defend than several. Raise it; the researcher decides.

**Analytic decisions are the researcher's.** Offer a recommendation with the
reason and the consequence of the alternative, then stop. Once decided, carry
the decision through the plan, the code, the decisions log and the report in
the same session, and do not re-ask.

## Reports

**Every analysis gets four things.** What we fitted and why, a table, a figure,
and a reading of the result. A CSV is not a table and a script is not a
method note.

**Every number in prose comes from the tables by code.** Inline R, helper
functions that look a value up by model, predictor and level, never a typed
number. When the tables change, the prose follows.

**Group by outcome.** Every sensitivity, supplement and check for an outcome
sits under that outcome's heading, in a fixed order, rather than in shared
sections at the end. A reader should never have to jump between sections to
see everything about one model.

**Check page fit mechanically, then by eye.** Scan every page of the rendered
PDF for text or image boxes crossing the margins; then look at the figure
pages, because text drawn inside an image is invisible to the scan. The
usual offenders: tables that grew a column, landscape tables wider than the
rotated text width, facet strip titles, legends with too many entries in one
row, and axis labels that run off. Wrap long titles, use `scale_down` or
landscape for wide tables, and put multi-fit figures on landscape pages.

**LaTeX and Markdown gotchas in Quarto.** A `$` in prose opens math; escape it
in Markdown and pass generated strings through an escaper. A
`\begin{landscape}` environment in raw text swallows the Markdown after it;
define one-word macros (`\blandscape`, `\elandscape`) instead. Arrow glyphs
are missing from Helvetica Neue; write "then".

**One rule for multiplicity, stated once.** Say what it is in the
introduction and apply it everywhere.

**Use the house theme and follow the visual-style rules.** One color for
estimates, orange only for "look here," the reference level as a hollow point,
no legend where position already encodes the category, sequential tints for
ordered categories, and never a color distinction without a second cue.

## Prose

**Read the style guide before writing anything the researcher will send under
their name.** For Sara: `~/.claude/weston_research_writing_style.md` and the
`sara-voice` skill, before the first sentence, not after. First-person plural,
active voice, the reason attached to every choice, a plain-language
restatement after each technical claim, honest calls on effect sizes,
labeled speculation.

**No causal language for one wave of data.** "Associated with," not
"predicts" or "causes." Where a question header says "predict," say in the
introduction that it is shorthand.

**Check every draft reading against the tables before it renders.** Two
sentences in a first draft claimed things the tables did not support; the
readings were caught by rereading them against the numbers.

## Process

**Explain a line of code by what it assumes.** When asked to walk through a
script, show the code, then the plain-English purpose, then the defaults the
function relies on and the decisions made where the plan left room, and
collect the assumptions in one list at the end.

**Keep the decisions log current for implementation choices too.** Reference
levels, complete-case rules, bootstrap settings, which model supplies which
number. A reviewer a year later asks about these.

**Save durable preferences as memories.** A rule the researcher states once
("package functions first") should hold in the next session without being
repeated.
