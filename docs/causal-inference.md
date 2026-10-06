# Instructions for AI assistants: causal inference with messy repeated data

Read this file when a project asks a reverse causal question ("why did Y
change?"), compares waves, cohorts, or sites whose instruments or samples
differ, or has a design change that was not randomized. It does not apply to
every study. `CLAUDE.md` holds the hard rules; this file is the working
practice for reasoning about rival explanations before settling on a story.

The worked example is Rohrer, McElreath, and Kachel (2026), "Why did the
gender gap in adolescent life satisfaction grow? Evaluating methodological and
demographic explanations," *Journal of Happiness Studies*, 27, 85
(https://doi.org/10.1007/s10902-026-01068-6). Code and annotated results:
https://j-rohrer.github.io/Jugendstudienanalysen/. The full text is in Sara's
Zotero library.

---

## The paper in one paragraph

Three school surveys in one city (2010, 2015, 2023) showed that girls were
less satisfied than boys and that the gap roughly doubled by 2023. The authors
treat this as a reverse causal question and work through rival explanations in
order. First, a scaling artifact: an ordered probit model gives the same
widening as the linear model. Second, sample composition: age, school type,
and migration background do not explain the widening, but the widening is much
larger among students with a migration background, and the composition of that
group very likely changed between waves. Third, a design change: the 2023
survey was partly on tablets, girls (not boys) reported lower satisfaction on
tablets, and restricting to paper responses removes roughly 30% of the
widening and nearly all of it among students without a migration background.
Last, the other satisfaction items show widening gaps in leisure and
friendships that survive all of the above. The paper ends with several stated
assumptions and says which result would stand if each were false.

---

## Moves to copy

**List the rival explanations before fitting anything, cheapest first.** For
a change over time or a gap between groups, the usual order is: the measure
(scaling, wording, mode), then who was sampled (composition, response,
coverage), then the substantive story. Test each one and report what it
removed. *Why:* the paper's headline narrative (social media) would have been
asserted from the raw gap alone; two of the three artifacts changed the
answer.

**Establish the pattern with the model you will extend.** Start with a
categorical-predictor model with the interaction of interest (here gender by
wave), reproduce the descriptive finding, and add terms one question at a
time. Every later number then answers "what changed when we added this?"

**Interactions are scale-dependent, so test the scale.** A widening gap is an
interaction and can appear or disappear under a monotone rescaling. For
Likert-type outcomes, refit as an ordered probit or logit and check that the
interaction survives. Where the question allows, let the thresholds differ by
group and report that too.

**Controlling for a confounder of an interaction means interacting it.** To
ask whether composition explains a change in a gap, interact every covariate
with both the moderator and the wave, and with their product (the three-way
terms). A main-effect covariate adjustment does not answer the question.

**Standardize by prediction, not by adjustment.** Fit the flexible model, then
predict for every observed unit under each level of the focal variable on a
fixed covariate distribution, and average the contrasts (`marginaleffects`).
Report the result under more than one reference distribution (first wave,
middle wave, last wave); the paper reports all three and they agree.

**A control is not enough when the group itself changed.** "Migration
background" was a single category in every wave, but the countries of origin
inside it shifted. When a covariate's meaning shifts across waves, model the
interaction, then find outside information on how the group changed
(administrative counts, census tables), and say what that implies. Where the
data cannot test the explanation (small cells), say so and give a back of the
envelope calculation with every assumption written out. If the calculation
implies an implausible value, say that too.

**For a design change, decide whether it is a cause or a marker.** Draw both
graphs. If mode causes the outcome, hold mode constant (restrict to the shared
mode). If mode only marks who ended up in which mode, restricting to one mode
selects on third variables and can add bias. The paper separates the two with
four checks: (1) is mode associated with the outcome and with the focal
interaction; (2) does the association survive adjustment for observed
differences between the modes; (3) does it survive when only within-cluster
variation is used (school fixed effects, with cluster-by-moderator
interactions), which is possible only where both modes occur inside the same
cluster; (4) what unobserved classroom-level confounding remains, stated in
words. Then state which assumption the final analysis rests on and report what
holds if it is false.

**Say how much was explained.** "Removes about 30% of the widening" is more
useful than "partly explains." Give the estimate before and after, with
intervals.

**Fit the same model to every outcome you have, and show all of them.**
Different domains behave differently here (some gaps appear only in one
subgroup), and that pattern is evidence about mechanism. Disclose every
outcome analyzed.

**State coverage and response.** Response rates by wave, share of the
population frame included, and what is not known about nonrespondents. A
falling response rate does not by itself imply more nonresponse bias, but it
belongs in the limitations.

**Cluster the standard errors at the sampling unit** (classroom or school in
the example) in every model.

**Label mechanisms as speculation.** The paper gives no confirmed mechanism
for the tablet effect and says it may be chance, since no one has reported it
before. Match that.

**De-emphasize the non-comparable wave and keep it in the figure.** See the
section of `CLAUDE.md` on planned analyses the data give reason to doubt.

---

## Using this in our own studies

**At design time.** Keep a change log of every difference between waves or
versions: item wording, response scale, mode, eligibility, sampling frame.
Where a change is unavoidable, field both versions in part of the sample (a
bridge sample) so the effect of the change can be estimated within cluster. Do
not let mode or version be perfectly confounded with wave. Collect the
detailed version of any covariate we may later need to unpack (country of
origin, not only a migration flag), because a coarse category cannot be taken
apart afterward.

**At preregistration.** Preregister the sequence of rival-explanation checks
as well as the forward test, and say which result would lead us to restrict
the sample or de-emphasize a wave. Anything added after seeing the data is
labeled exploratory.

**In the pipeline.** Carry the design variables the checks need as columns
built in `code/02_derive.R` (wave, mode or version, cluster, and a comparability
flag). Write the model sequence as a table of specifications and map over it,
so each step differs from the previous one in one stated way (see
`docs/analysis-code-and-reporting.md`). Restrict every step to the same rows
when a comparison is across steps.

**In the decisions log.** Each fork in the paper is a `docs/decisions.md`
entry: which assumption the headline rests on, what the alternative assumption
would give, and whether the choice was made before or after seeing results.

**In reports.** Give the headline under each assumption it depends on when
they differ, in prose, with the estimates. Use "if ... then" for causal
claims that rest on untestable assumptions, and name the assumption.

---

## What to do as the assistant

**Flag, do not choose.** Whether to restrict the sample to one mode, whether to
treat a design variable as a cause or a marker, and which reference
distribution to standardize to are analytic decisions (see `CLAUDE.md`). Lay
out the options and what each assumes, run them side by side if asked, and let
Sara decide.

**Do not invent the outside information.** Population counts, historical
context, and literature on a mechanism come from a source Sara can cite, not
from memory.

**Do not narrate a mechanism the data cannot reach.** If an explanation cannot
be tested with the data at hand, say that and stop.
