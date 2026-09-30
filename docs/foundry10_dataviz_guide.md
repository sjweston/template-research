# Data Visualization Guide for foundry10 Research Outputs

This guide combines two sources: the foundry10 Visual Style Guide (v5.0, February 2025) and the storytelling with data (SWD) + AI primer, which excerpts *storytelling with data: before & after* (Wiley, 2025). The SWD material supplies the process and the design logic; the foundry10 guide supplies the colors, type, and accessibility rules. Where the two sources disagree, foundry10 wins. Those conflicts and how they were resolved are listed in the last section so nobody has to guess.

It is written to sit alongside `theme_foundry10.R`, which implements the brand rules for ggplot2. Function names from that file are referenced where relevant.

---

## 1. Before you plot: message, audience, and mode

SWD's core move is to separate two kinds of graphs. Exploratory graphs are for you: fast, ugly, many. Explanatory graphs are for an audience, and every design decision below applies only to the second kind. Do not polish exploratory plots, and do not put an unpolished exploratory plot in anything that leaves the team.

For every explanatory graph, answer three questions before touching the code:

1. **Who is the audience?** foundry10's guide sorts audiences roughly into two camps: researchers, funders, higher-ed, and media on one side; youth, K-12 educators, families, and community partners on the other. The second group generally needs less statistical machinery on the figure itself (fewer CIs, fewer model terms) and more plain-language labeling. This is a level-of-detail decision, not a permission to hide uncertainty.
2. **What is the one thing they should take away?** SWD's test: if someone asked "what's the point here?", what would you say in one sentence? List the two or three plausible takeaways from the data, pick one, and design for it. A graph built to say everything usually says nothing.
3. **Will it be read alone or presented?** A figure in a report or a LinkedIn post has to carry all of its context in the title, labels, and annotations. A slide with a presenter can be sparer. Most foundry10 research output is read alone, so default to self-contained.

For research reports specifically, the takeaway must still be an honest description of the data. See section 4 on titles.

## 2. Choose a common graph (mostly)

SWD's working set is six chart types, and they cover nearly everything we do: horizontal bar, vertical bar, stacked bar, dot plot, slopegraph, line graph. Reach for these first.

| Question the graph answers | Default form | Notes |
|---|---|---|
| How do groups compare on one measure? | Horizontal bar | Sort by value unless the categories have a natural order. Horizontal so labels read cleanly. |
| How does one measure change over ordered categories or time? | Vertical bar (few periods) or line (many) | Lines imply continuity; don't use them for unordered categories. |
| How does composition compare across groups? | Stacked bar (100%) | Keep to 3-4 segments; order segments consistently. Diverging stacked bars for Likert data (see section 5). |
| How do groups compare on a measure, with uncertainty? | Dot plot with interval | This is the workhorse for estimates and CIs. Dots plus a line beat bars with error whiskers. |
| How did two time points differ across groups? | Slopegraph | Best for pre/post across a handful of groups. |
| How is a continuous variable distributed? | Histogram, density, or dot-and-interval | Not in SWD's six but essential for research; keep the same styling rules. |

Things that need a specific reason:

- **Pie and donut charts.** Not in SWD's set. The foundry10 guide only uses them as "don't" examples. If one is unavoidable, three slices maximum and label every slice directly.
- **Dual axes.** Almost always misread. Use two panels instead.
- **Novel or specialist forms** (ridgelines, alluvials, raincloud plots). SWD's rule: the audience has to learn to read the graph before they can read the data, so only pay that cost when the form shows something a common graph cannot. Fine for a methods audience; rarely fine for a community partner.

Any dataset can be plotted several reasonable ways. Don't agonize over the choice; a solid common graph with good design beats a clever one with defaults left on.

## 3. Declutter, then add back deliberately

SWD's process is two-directional: strip the graph to its essentials, then add back only what directs attention or adds meaning. Stopping after step one leaves a bare, unhelpful figure.

Remove by default (the theme does most of this):

- Chart borders and panel backgrounds
- Gridlines in both directions (add back light horizontal lines only when readers need to look up values)
- Tick marks
- Redundant data labels (a label on every bar plus an axis is double-encoding)
- Trailing decimals and unnecessary precision (percentages as whole numbers unless the difference matters)
- Legends, wherever direct labeling can replace them
- Decorative effects: shadows, 3D, gradients on data marks

The foundry10 guide is explicit that gradients are for backgrounds and emphasis in layout design, not for data marks.

Then add back:

- A takeaway or descriptive title (section 4)
- Axis titles, even when they feel redundant with the graph title
- Direct labels on the series that matter
- One or two annotations that explain the thing you want people to see
- A source or n line in the caption

## 4. Titles and labels

Every graph gets a title. Every axis gets a title. Every plotted series gets a label, ideally placed next to the data rather than in a legend. SWD's point is that readers scan from top-left in a Z pattern, so the title and axis title framed at the upper left tell them what they are looking at before they hit the data.

SWD distinguishes two title types:

- **Descriptive title**: what the graph shows ("Weekly hours on homework, by grade band"). Use this on the graph itself.
- **Takeaway title**: what the graph means ("Homework hours rise sharply between 8th and 9th grade"). Use this on the slide, report figure heading, or social post that carries the graph.

In `theme_foundry10()` the convention is: `title` = takeaway (bold, larger), `subtitle` = descriptive title with units, `caption` = source, n, and any exclusions. If a figure has no takeaway (it's a reference or supplement figure), leave `title` empty and put the descriptive title in `subtitle` so the type hierarchy stays consistent across the document.

**Research constraint on takeaway titles.** SWD is written for business communication, where a title can say "X drove Y." Ours can't unless the design supports it. With one wave of survey data, takeaway titles describe patterns ("Students who report more autonomy also report more engagement"), never mechanisms ("Autonomy increases engagement"). The title is still allowed to have a point of view; it just has to be a point of view the data can support.

Label rules that come from the foundry10 guide:

- Never rely on color alone to identify a series or mark emphasis. Pair color with a direct label, weight, or shape.
- Don't replace words with icons or emoji in labels; screen readers can't follow them.
- Headings on a figure should be at least 150% the size of body text. The theme sets `plot.title` at 1.5× base.

## 5. Color

This section is where the foundry10 guide is most prescriptive and where it overrides SWD. Read it twice.

### The palette

Primary: foundry10 Orange `#D14E1D`, Dark Cyan `#01646F`, Black `#111111`, Paper White `#F9F9F9`.

Secondary cyans: Warm `#077A8A`, Cool `#007079`, Bright `#078B9C`, Very Dark `#0E2528`. Secondary oranges: Light `#F9A65F`, Soft `#E77C53`, Text `#CA4A1C`, Web-safe background `#BE5127`.

Tints: 80% Orange `#D96F50`, 20% `#EBC5B9`, 10% `#F4E6E2`; 80% Dark Cyan `#326A72`, 20% `#AEC4C6`, 10% `#E0ECED`.

Grays (use sparingly): `#575857`, `#939598`, `#E2E3E4`, `#F2F2F2`.

All of these are exported from `theme_foundry10.R` as the named vector `f10_colors`.

### Rules

1. **Minimize the number of colors.** SWD and foundry10 agree. Most explanatory graphs need one accent color plus gray. Two accents is the practical ceiling for categorical data; if you need more, ask whether small multiples would be clearer.
2. **Gray is the default for everything that isn't the point.** Comparison groups, benchmarks, prior years, other schools: gray. The thing the title is about: color. This is SWD's "show people where to look" implemented with foundry10's palette.
3. **Orange draws the eye.** The foundry10 guide notes that the brand oranges act as accent colors and pull attention. That makes orange the natural highlight color, with one big exception below.
4. **Orange means negative; cyan means positive.** This is a hard rule in the style guide and its "don't" example is literally a pie chart with orange "yes" responses. So: agree/likely/improved/positive in cyans, disagree/unlikely/declined/negative in oranges. Neutral or middle categories in gray. This applies to Likert scales, pre/post change, and any valenced outcome.
5. **Similar colors group related things.** Use tints of the same hue for ordinal steps ("very likely" and "likely" both cyan, differing in lightness). Use different hues for genuinely different groups.
6. **Never repeat a color in a key.** If you have eight categories, you need eight distinguishable colors, which is your signal to collapse categories or facet.
7. **Neutral highlighting.** When the highlighted thing is neither good nor bad (this school vs. others, this year vs. prior years), use Dark Cyan as the accent rather than orange, so the highlight doesn't read as a negative judgment. Orange is available when you need a second highlight or when the finding really is a concern.

### Palettes implemented in the theme file

- `f10_pal("cat")`: categorical, ordered by contrast: dark cyan, orange, bright cyan, light orange, dark gray, soft orange. Stops at six; beyond that the function warns.
- `f10_pal("seq_cyan")` and `f10_pal("seq_orange")`: sequential, light to dark, for ordered or continuous data.
- `f10_pal("div")`: diverging, orange through light gray to cyan, for valenced scales centered on neutral.
- `f10_pal("likert5")` and `f10_pal("likert7")`: ready-made ordinal palettes that follow the negative-orange / positive-cyan rule with a gray middle.
- `f10_pal("highlight")`: dark cyan for the focal group, medium gray for everything else.

### Accessibility checks before a figure ships

- **Contrast.** From the foundry10 guide: orange `#D14E1D` on white passes only at 14pt/18px or larger; for smaller colored text on white use Text Orange `#CA4A1C`. Orange on Dark Cyan fails. Orange on black fails; use Bright Cyan on black. White on orange passes at 14pt+. The theme uses `#CA4A1C` for small annotation text by default.
- **Color vision.** Orange and cyan differ in lightness as well as hue, so the pairing survives most simulated deficiencies, but check anyway: `colorspace::deutan()` / `protan()` on the palette, or `colorblindr::cvd_grid()` on the plot.
- **Redundancy.** Every color distinction should also be carried by a label, position, or line type. Check this by imagining the figure in grayscale. If it stops working, add labels.
- **Font size.** Nothing on the figure below 9pt in print or 16px on the web. In ggplot terms, keep `base_size` at 11 or above when the figure will be rendered at 6-7 inches wide.

## 6. Typography and layout

- Typeface is Helvetica Neue, falling back to Arial when it isn't installed. `theme_foundry10()` checks which is available with `systemfonts` and picks accordingly. Don't substitute another face without checking with Comms.
- Left-align titles, subtitles, and captions to the plot edge (not the panel), so they frame the whole figure the way SWD recommends. The theme does this with `plot.title.position = "plot"`.
- No italics for anything longer than a phrase.
- Text is black `#111111` on Paper White or true white. Don't put figures on dark backgrounds in reports; a dark variant exists in the theme file for slides and social only.
- Whitespace separates elements; borders and boxes don't.

## 7. Figures in research reports

These are the conventions that this guide adds for foundry10 research output specifically. They don't come from either source document; they come from how our reports are structured.

- Every reported analysis gets a method note, a table, a figure, and a reading. The figure is not a replacement for the table; it is the interpretation layer. Numbers quoted in prose come from the table, not read off the figure.
- Show uncertainty on estimates (interval around a dot, ribbon around a line). Choose one interval convention per document and state it once in the methods.
- Include n in the caption. Include the wave or data-collection window in the subtitle or caption.
- If an outcome was collapsed, transformed, or filtered for the figure, say so in the caption, and never collapse an ordinal outcome to binary just to make the figure simpler without noting it as an analytic change.
- Group all of an outcome's supplementary figures under that outcome's heading, styled identically to the main figure.
- Before rendering: check every figure for clipped titles, legends, and axis labels, and check every page for margin overflow.

## 8. Formats and export

- Vector where possible: PDF or SVG for reports and anything print-bound. PNG at 300 dpi when raster is required (Word, most web CMSs).
- Standard report figure width is 6.5 inches (full text width); half-width figures at 3.1 inches need `base_size` bumped so the type stays above 9pt.
- Social: 1080 × 1080 or 1080 × 1350 px, with larger type (`base_size = 18` or more) and the dark variant allowed.
- Use `f10_save()` from the theme file, which sets these defaults and forces a white background.
- Save the data behind every explanatory figure as a CSV alongside it so the figure can be rebuilt.

## 9. Pre-flight checklist

Run this on every explanatory figure. It condenses everything above.

1. I can state the takeaway in one sentence, and the title says it (or the subtitle describes it, if there's no takeaway).
2. The chart type is one of the common six, or I have a specific reason it isn't.
3. Axes are titled with units. Series are labeled directly. No legend unless it's unavoidable.
4. Gridlines, borders, ticks, and redundant labels are gone. Precision matches what the reader needs.
5. Only the focal series is colored; everything else is gray.
6. Orange is used only for negative or concerning values; cyan for positive; gray for neutral. Related categories share a hue.
7. No color appears twice in a key. No more than six categorical colors.
8. Every color distinction is also carried by a label or position. The figure works in grayscale.
9. Small colored text is `#CA4A1C`, not `#D14E1D`. Nothing is below 9pt/16px.
10. Uncertainty is shown, n and source are in the caption, and no causal language appears anywhere for single-wave data.
11. The rendered figure has no clipped text and fits the page.

## 10. Where the sources disagree, and what we do

| Topic | SWD primer | foundry10 style guide | Resolution |
|---|---|---|---|
| Highlight color | Any single saturated color (examples use navy, green) with gray for the rest | Brand colors only; orange is the attention-grabber | Use brand palette. Default highlight is Dark Cyan for neutral emphasis; orange only when the highlighted value is negative, or as a second accent. |
| Meaning of color | Color is purely a focusing device | Orange = negative, cyan = positive | foundry10 rule applies even when it means the eye-catching orange lands on the bad news. That's usually the right emphasis anyway. |
| Focusing attention | Color is the fastest way to direct attention | Never rely on color alone | Do both: color to focus, plus a direct label, weight, or annotation that carries the same distinction. |
| Takeaway titles | Recommended everywhere, can assert causes and recommend actions | Silent on titles | Takeaway titles yes, but descriptive of patterns, not mechanisms, and no action recommendations on research figures. Actions go in the report's discussion, not the figure. |
| Gradients | Not addressed | Sparingly, for decorative backgrounds; check legibility | No gradients on data marks. Sequential palettes are stepped, not smooth, unless the variable is continuous. |
| Pie charts | Omitted from the common set | Shown only in "don't" examples | Avoid. Three slices max if forced. |
| Tools | Examples in Excel and PowerPoint | Not addressed | ggplot2 with `theme_foundry10()`; principles transfer directly. |

---

*Sources: foundry10 Visual Style Guide v5.0 (Feb 2025); storytelling with data + AI primer, excerpting* storytelling with data: before & after *(Wiley, 2025). SWD principles are paraphrased; see the primer or storytellingwithdata.com/chart-guide for the original discussion and examples.*
