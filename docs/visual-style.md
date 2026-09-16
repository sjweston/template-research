# Visual style rules

Derived from the foundry10 Visual Style Guide, Version 5.0 (February 2025),
pages 9-21. This file is the working version for figures and tables produced in
this repository. The guide itself is the authority; where this file is silent,
read the guide.

Questions about the brand go to Curtis Rogers, Director of Communications.

The ggplot implementation is `code/functions/theme_foundry10.R`. Changing a
colour here means changing it there too.

---

## Colours

### Primary palette

| Name | Hex | Use |
|---|---|---|
| foundry10 orange | `#D14E1D` | accent only — draws the eye |
| foundry10 dark cyan | `#01646F` | default colour for data marks |
| black | `#111111` | text |
| paper white | `#F9F9F9` | background |


### Secondary palette

Cyans, light to dark: `#078B9C` bright, `#077A8A` warm, `#007079` cool,
`#01646F` primary, `#0E2528` very dark.

Oranges: `#F9A65F` light, `#E77C53` soft, `#D14E1D` primary, `#CA4A1C` text,
`#BE5127` web-safe background.

### Tints

Use to widen the palette without reducing opacity.

Orange: 80% `#D96F50`, 20% `#EBC5B9`, 10% `#F4E6E2`.
Cyan: 80% `#326A72`, 20% `#AEC4C6`, 10% `#E0ECED`.

### Grayscale

`#000000`, `#575857` dark, `#939598` medium dark, `#E2E3E4` light,
`#F2F2F2` very light, `#FFFFFF`. Use sparingly. This is also the palette for
print materials that will not be printed in colour.

---

## Rules for charts

From p.17 of the guide, plus what follows from them for this project.

1. **Minimise the number of colours.** If position already encodes the
   category, do not also encode it with colour. In this project subgroup levels
   sit on an axis, so they are all one colour.
2. **Orange is an accent.** It pulls attention, so it marks the thing the
   reader should notice and nothing else.
3. **Secondary and unimportant elements go gray, black, or very light.**
   Gridlines, reference lines, and annotations are gray.
4. **Similar tints group related information.** Similar shades of cyan for
   related response options ("Very important" and "Important").
5. **Never repeat a colour in a chart key.**
6. **Orange means negative or bad; cyan means positive or good.** This applies
   when values carry a valence. The estimates in this project are descriptive
   and carry none, so they are cyan by default and the good/bad convention does
   not apply — orange here means "look at this", not "this is bad".

## Accessibility

These are not optional.

7. **Never rely solely on colour** to categorise, emphasise, or prompt. Every
   colour distinction carries a second cue — shape, weight, or text. In this
   project the test result is printed as text on every figure, so colour
   emphasis is always supplementary.
8. **Suppressed and imprecise estimates are marked by shape, not colour.** A
   hollow point means the estimate rests on fewer than 30 students. A missing
   point with its label retained means the cell was suppressed.
9. **Contrast.** Do not set text smaller than 14pt/18px in `#D14E1D` on white —
   use `#CA4A1C` instead. White text on `#D14E1D` needs to be 14pt/18px or
   larger. Check solid backgrounds with a WCAG contrast checker.

---

## Typography

Helvetica Neue, in any weight. Arial where it is unavailable. Anything else
goes past Comms first.

- Minimum 9pt for print, 16px for web. Figure text in this project does not go
  below 9pt.
- Headings at least 150% the size of body copy, and visually distinct.
- Avoid italics for long passages.
- Never centre or justify long blocks of text.
- Use whitespace to separate sections.

---

## What this means for a figure in this repository

- Estimates are dark cyan points; a Holm-significant comparison turns orange,
  and the printed p-value says so in text as well.
- Confidence intervals are drawn as asymmetric bars from the stored bounds,
  never as a symmetric margin of error — the proportion intervals are logit
  intervals.
- The all-students estimate is a gray dashed reference line.
- Gridlines are very light gray; no panel border, no background fill.
- Every figure prints its test statistic, raw p, and Holm-corrected p.
