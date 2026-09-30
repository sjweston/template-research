# theme_foundry10.R
#
# A ggplot2 theme, color palettes, and scale helpers that implement the
# foundry10 Visual Style Guide (v5.0, Feb 2025) together with storytelling
# with data (SWD) design principles. Read alongside foundry10_dataviz_guide.md.
#
# Usage:
#   source("R/theme_foundry10.R")
#   ggplot(df, aes(x, y)) + geom_col() + theme_foundry10()
#
# Everything here is plain ggplot2 / grid / systemfonts. No package build needed;
# just source the file at the top of the analysis script or in a project .Rprofile.
#
# NOTE: this file was written without an R session available to test it. Run
# the self-test at the bottom (`f10_selftest()`) the first time you source it
# and fix anything that breaks before relying on it.

# ---- Dependencies ------------------------------------------------------------

# systemfonts is only needed for font detection. If it's missing we fall back to
# "sans" rather than failing, so the theme still works on a bare install.
.f10_has_systemfonts <- requireNamespace("systemfonts", quietly = TRUE)

# ---- Brand colors ------------------------------------------------------------

# Every hex value below is copied from the style guide's color pages (pp. 10-13).
# Named so that code reads as intent ("orange", "text_orange") rather than hex.
f10_colors <- c(
  # Primary palette (p. 10)
  orange          = "#D14E1D",  # primary accent; draws attention; NEGATIVE valence
  dark_cyan       = "#01646F",  # headlines, backgrounds; POSITIVE valence
  black           = "#111111",  # body text
  paper_white     = "#F9F9F9",
  # Secondary cyans and oranges (p. 11)
  warm_cyan       = "#077A8A",
  cool_cyan       = "#007079",
  bright_cyan     = "#078B9C",  # the only cyan that passes on a black background
  very_dark_cyan  = "#0E2528",
  light_orange    = "#F9A65F",
  soft_orange     = "#E77C53",
  text_orange     = "#CA4A1C",  # use for orange text < 14pt on white (p. 15)
  bg_orange       = "#BE5127",
  # Tints of the primaries (p. 12)
  orange_80       = "#D96F50",
  orange_20       = "#EBC5B9",
  orange_10       = "#F4E6E2",
  dark_cyan_80    = "#326A72",
  dark_cyan_20    = "#AEC4C6",
  dark_cyan_10    = "#E0ECED",
  # Grayscale (p. 13) - the guide says use sparingly, but for data viz gray is
  # the default for everything that isn't the point (SWD), so we lean on these.
  dark_gray       = "#575857",
  medium_gray     = "#939598",
  light_gray      = "#E2E3E4",
  very_light_gray = "#F2F2F2",
  white           = "#FFFFFF"
)

# Convenience accessor: f10("orange") -> "#D14E1D". Errors on a typo instead of
# silently returning NA, which would make a mark invisible.
f10 <- function(...) {
  nm <- c(...)
  out <- f10_colors[nm]
  if (anyNA(out)) stop("Unknown foundry10 color(s): ", paste(nm[is.na(out)], collapse = ", "))
  unname(out)
}

# ---- Palettes ----------------------------------------------------------------

# The style guide's data-viz rules (p. 17) drive every palette here:
#   - minimize the number of colors
#   - similar hues group related things (tints for ordinal steps)
#   - orange = negative, cyan = positive, gray = neutral / unimportant
#   - never repeat a color in a key
.f10_palettes <- list(

  # Categorical, ordered so the first k colors are always the most distinct k.
  # Capped at six on purpose: past that, the guide's "never repeat a color" rule
  # can't be honored legibly and you should facet or collapse instead.
  cat = c("#01646F", "#D14E1D", "#078B9C", "#F9A65F", "#575857", "#E77C53"),

  # Sequential ramps, light -> dark, built from the tint pages so every step is a
  # sanctioned brand color rather than an interpolated one.
  seq_cyan   = c("#E0ECED", "#AEC4C6", "#326A72", "#01646F", "#0E2528"),
  seq_orange = c("#F4E6E2", "#EBC5B9", "#D96F50", "#D14E1D", "#BE5127"),

  # Diverging: negative (orange) through neutral gray to positive (cyan).
  # Gray, not white, in the middle so the neutral category is still visible on
  # a white background.
  div = c("#D14E1D", "#D96F50", "#EBC5B9", "#E2E3E4", "#AEC4C6", "#326A72", "#01646F"),

  # Likert / agreement scales. Ordered from most negative to most positive so
  # they line up with factor levels ordered the same way. Middle is gray.
  likert5 = c("#D14E1D", "#EBC5B9", "#939598", "#AEC4C6", "#01646F"),
  likert7 = c("#BE5127", "#D14E1D", "#EBC5B9", "#939598", "#AEC4C6", "#326A72", "#01646F"),
  # Four-point (no neutral) version, same valence rule
  likert4 = c("#D14E1D", "#EBC5B9", "#AEC4C6", "#01646F"),

  # Highlight: the focal group in dark cyan, everything else in medium gray.
  # Dark cyan rather than orange because a neutral highlight (this school vs
  # others) shouldn't read as a negative judgment. Use "highlight_neg" when the
  # focal thing IS the concern.
  highlight     = c("#01646F", "#939598"),
  highlight_neg = c("#D14E1D", "#939598")
)

# Return n colors from a named palette. For sequential/diverging palettes with
# n larger than the stored ramp, interpolate; for categorical, refuse, because
# interpolating categorical colors produces near-duplicates and breaks the
# "never repeat a color" rule.
f10_pal <- function(name = "cat", n = NULL, reverse = FALSE) {
  if (!name %in% names(.f10_palettes)) {
    stop("Unknown palette '", name, "'. Options: ", paste(names(.f10_palettes), collapse = ", "))
  }
  pal <- .f10_palettes[[name]]
  if (reverse) pal <- rev(pal)
  if (is.null(n)) return(pal)
  if (n <= length(pal)) return(pal[seq_len(n)])
  if (name %in% c("cat", "highlight", "highlight_neg") || grepl("^likert", name)) {
    stop("Palette '", name, "' has ", length(pal), " colors; you asked for ", n,
         ". Collapse categories or facet rather than adding colors.")
  }
  grDevices::colorRampPalette(pal)(n)
}

# ---- ggplot2 scales ----------------------------------------------------------

# Discrete color/fill scales. `palette` is any name in .f10_palettes.
# Example: + scale_fill_f10("likert5")
scale_color_f10 <- function(palette = "cat", reverse = FALSE, ...) {
  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) f10_pal(palette, n, reverse), ...
  )
}
scale_colour_f10 <- scale_color_f10

scale_fill_f10 <- function(palette = "cat", reverse = FALSE, ...) {
  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) f10_pal(palette, n, reverse), ...
  )
}

# Continuous scales for sequential/diverging data.
# Example: + scale_fill_f10_c("seq_cyan")   or   + scale_color_f10_c("div", midpoint = 0)
scale_color_f10_c <- function(palette = "seq_cyan", reverse = FALSE, ...) {
  ggplot2::scale_colour_gradientn(colours = f10_pal(palette, reverse = reverse), ...)
}
scale_colour_f10_c <- scale_color_f10_c

scale_fill_f10_c <- function(palette = "seq_cyan", reverse = FALSE, ...) {
  ggplot2::scale_fill_gradientn(colours = f10_pal(palette, reverse = reverse), ...)
}

# ---- Fonts -------------------------------------------------------------------

# The guide's typeface is Helvetica Neue, with Arial as the sanctioned fallback
# (p. 19). We detect what's installed rather than hard-coding a name, because a
# missing font family makes ggplot warn on every draw and silently substitute.
f10_font <- function() {
  if (!.f10_has_systemfonts) return("sans")
  installed <- unique(systemfonts::system_fonts()$family)
  candidates <- c("Helvetica Neue", "HelveticaNeue", "Helvetica", "Arial")
  hit <- candidates[candidates %in% installed]
  if (length(hit) == 0) "sans" else hit[1]
}

# ---- The theme ---------------------------------------------------------------

# theme_foundry10() encodes the SWD "declutter" defaults and the foundry10 type
# rules. Arguments let you add back the few things that are sometimes needed
# without editing theme_* calls in every script.
#
# base_size:   11 is safe for a 6.5-inch report figure; the guide's floor is
#              9pt print / 16px web, so bump this for half-width or web figures.
# grid:        "none" (SWD default), "y", "x", or "xy". Horizontal lines are the
#              usual add-back when readers need to look up values on a bar chart.
# axis_line:   draw the x/y axis lines (off by default; bars/points anchor the
#              eye well enough without them).
# legend:      legend position; default "none" because direct labels are the
#              house style. Pass "bottom" / "right" etc. when a legend is really
#              needed (e.g. stacked Likert bars, where labeling every segment
#              is worse than a key).
# dark:        TRUE gives the very-dark-cyan background variant for slides and
#              social only; never for report figures (guide p. 15 contrast rules).
theme_foundry10 <- function(base_size = 11,
                            base_family = f10_font(),
                            grid = c("none", "y", "x", "xy"),
                            axis_line = FALSE,
                            legend = "none",
                            dark = FALSE) {
  grid <- match.arg(grid)

  # Color roles. On the dark variant we swap text to paper white and use bright
  # cyan for accents, which is the only cyan the guide approves on black (p. 15).
  txt      <- if (dark) f10("paper_white") else f10("black")
  txt_soft <- if (dark) f10("dark_cyan_20") else f10("dark_gray")
  bg       <- if (dark) f10("very_dark_cyan") else f10("white")
  gridcol  <- if (dark) f10("dark_cyan_80") else f10("light_gray")
  axiscol  <- if (dark) f10("dark_cyan_20") else f10("dark_gray")

  # Start from theme_minimal, which already drops the panel border and background,
  # then strip and restyle the rest.
  th <- ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      # --- Text hierarchy. Title is 1.5x base because the guide requires
      # headings at least 150% larger than body copy (p. 20). Title is bold and
      # left-aligned to the *plot* edge so it frames the graph (SWD: readers
      # start top-left and scan in a Z).
      plot.title = ggplot2::element_text(
        size = ggplot2::rel(1.5), face = "bold", colour = txt,
        hjust = 0, margin = ggplot2::margin(b = base_size * 0.4)
      ),
      # Subtitle carries the descriptive title (what/units); regular weight so
      # it reads as secondary to the takeaway.
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(1), colour = txt_soft, hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.8)
      ),
      # Caption is for source / n / exclusions. Left-aligned to match, and not
      # italic (guide: avoid italics beyond a phrase, p. 19).
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(0.8), colour = txt_soft, hjust = 0,
        margin = ggplot2::margin(t = base_size * 0.8)
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",

      # --- Axes. Titles kept (SWD: always title axes, even when redundant).
      # Ticks removed as clutter. Axis text in dark gray so it sits behind the
      # data marks visually.
      axis.title = ggplot2::element_text(size = ggplot2::rel(0.9), colour = txt_soft),
      axis.title.x = ggplot2::element_text(hjust = 0, margin = ggplot2::margin(t = base_size * 0.5)),
      axis.title.y = ggplot2::element_text(hjust = 1, margin = ggplot2::margin(r = base_size * 0.5)),
      axis.text = ggplot2::element_text(size = ggplot2::rel(0.85), colour = txt_soft),
      axis.ticks = ggplot2::element_blank(),
      axis.line = if (axis_line) ggplot2::element_line(colour = axiscol, linewidth = 0.4) else ggplot2::element_blank(),

      # --- Gridlines. All off by default; the `grid` argument adds back major
      # lines in one direction. Minor gridlines are never drawn.
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = if (grid %in% c("x", "xy")) ggplot2::element_line(colour = gridcol, linewidth = 0.3) else ggplot2::element_blank(),
      panel.grid.major.y = if (grid %in% c("y", "xy")) ggplot2::element_line(colour = gridcol, linewidth = 0.3) else ggplot2::element_blank(),

      # --- Backgrounds. Explicit white (or dark) so exported PNGs don't come out
      # transparent and get a gray fill in Word.
      plot.background = ggplot2::element_rect(fill = bg, colour = NA),
      panel.background = ggplot2::element_rect(fill = bg, colour = NA),

      # --- Legend. Off by default in favor of direct labels; when on, no title
      # box, no key border, placed where asked.
      legend.position = legend,
      legend.title = ggplot2::element_text(size = ggplot2::rel(0.9), colour = txt_soft),
      legend.text = ggplot2::element_text(size = ggplot2::rel(0.85), colour = txt),
      legend.key = ggplot2::element_blank(),
      legend.background = ggplot2::element_blank(),

      # --- Facets. Strip text left-aligned and bold, no strip background box,
      # so small multiples read as labeled panels rather than tabs.
      strip.text = ggplot2::element_text(
        size = ggplot2::rel(0.95), face = "bold", colour = txt, hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.4)
      ),
      strip.background = ggplot2::element_blank(),
      panel.spacing = grid::unit(base_size * 1.2, "pt"),

      # --- Outer margin. Enough that titles never kiss the edge of the export.
      plot.margin = ggplot2::margin(base_size, base_size, base_size, base_size)
    )
  th
}

# ---- Geom defaults -----------------------------------------------------------

# Set default colors for common geoms so an un-scaled plot is already on-brand:
# bars and points in dark cyan (neutral-positive), lines in dark cyan, text in
# body black. Call once after sourcing. This is a side effect, so it lives in a
# function rather than running on source.
f10_set_geom_defaults <- function() {
  ggplot2::update_geom_defaults("bar",      list(fill = f10("dark_cyan")))
  ggplot2::update_geom_defaults("col",      list(fill = f10("dark_cyan")))
  ggplot2::update_geom_defaults("point",    list(colour = f10("dark_cyan"), size = 2.2))
  ggplot2::update_geom_defaults("line",     list(colour = f10("dark_cyan"), linewidth = 0.8))
  ggplot2::update_geom_defaults("pointrange", list(colour = f10("dark_cyan")))
  ggplot2::update_geom_defaults("errorbar", list(colour = f10("dark_gray")))
  ggplot2::update_geom_defaults("text",     list(colour = f10("black"), size = 3.5))
  ggplot2::update_geom_defaults("label",    list(colour = f10("black"), size = 3.5))
  invisible(NULL)
}

# ---- Annotation helper -------------------------------------------------------

# Colored annotation text on white. The guide (p. 15) says the primary orange
# fails contrast for text under 14pt/18px on white, so annotations default to
# text_orange (#CA4A1C). Cyan annotations use dark_cyan, which passes at all
# sizes. `valence` picks the hue so the orange/cyan meaning rule is honored.
f10_annotate <- function(x, y, label, valence = c("neutral", "negative", "positive"),
                         size = 3.5, hjust = 0, ...) {
  valence <- match.arg(valence)
  col <- switch(valence,
                neutral  = f10("dark_gray"),
                negative = f10("text_orange"),
                positive = f10("dark_cyan"))
  ggplot2::annotate("text", x = x, y = y, label = label, colour = col,
                    size = size, hjust = hjust, family = f10_font(), ...)
}

# ---- Export ------------------------------------------------------------------

# Wrapper around ggsave with report defaults: 6.5 in wide (full text width),
# 300 dpi, forced white background. Half-width figures should pass width = 3.1
# and a larger base_size in the theme so type stays above 9pt.
f10_save <- function(filename, plot = ggplot2::last_plot(),
                     width = 6.5, height = 4, dpi = 300, bg = "white", ...) {
  ggplot2::ggsave(filename, plot = plot, width = width, height = height,
                  dpi = dpi, bg = bg, ...)
}

# ---- Self-test ---------------------------------------------------------------

# Builds three plots that exercise the theme, scales, and helpers. Run once after
# sourcing on a new machine; returns the plots invisibly so you can print them.
f10_selftest <- function() {
  stopifnot(requireNamespace("ggplot2", quietly = TRUE))
  f10_set_geom_defaults()

  # 1. Highlight bar chart: focal group cyan, rest gray, direct labels, no legend
  d1 <- data.frame(
    school = c("A", "B", "C", "D", "E"),
    pct = c(62, 48, 71, 55, 40),
    focal = c(FALSE, FALSE, TRUE, FALSE, FALSE)
  )
  p1 <- ggplot2::ggplot(d1, ggplot2::aes(x = pct, y = stats::reorder(school, pct), fill = focal)) +
    ggplot2::geom_col(width = 0.7) +
    ggplot2::geom_text(ggplot2::aes(label = paste0(pct, "%")), hjust = -0.15, size = 3.2) +
    scale_fill_f10("highlight", reverse = TRUE) +
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0, 0.12))) +
    ggplot2::labs(
      title = "School C reports the highest rate of weekly participation",
      subtitle = "Percent of students participating at least weekly, by school",
      x = "Percent of students", y = NULL,
      caption = "Source: Spring survey, n = 1,204. Excludes students with fewer than 3 responses."
    ) +
    theme_foundry10()

  # 2. Diverging Likert bars: negative orange, positive cyan, neutral gray, legend on
  d2 <- data.frame(
    item = rep(c("I feel safe", "I belong", "Adults listen"), each = 5),
    response = factor(rep(c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree"), 3),
                      levels = c("Strongly disagree", "Disagree", "Neutral", "Agree", "Strongly agree")),
    pct = c(5, 10, 20, 40, 25, 8, 15, 22, 35, 20, 12, 18, 25, 30, 15)
  )
  p2 <- ggplot2::ggplot(d2, ggplot2::aes(x = pct, y = item, fill = response)) +
    ggplot2::geom_col(width = 0.7) +
    scale_fill_f10("likert5") +
    ggplot2::labs(
      title = "Most students agree they feel safe and that they belong",
      subtitle = "Distribution of responses, percent",
      x = "Percent of students", y = NULL, fill = NULL
    ) +
    theme_foundry10(legend = "bottom")

  # 3. Line with highlighted series and annotation
  d3 <- data.frame(
    year = rep(2021:2025, 3),
    group = rep(c("This district", "State", "Peer districts"), each = 5),
    val = c(52, 55, 53, 58, 63, 50, 51, 52, 52, 53, 49, 50, 52, 54, 55)
  )
  p3 <- ggplot2::ggplot(d3, ggplot2::aes(year, val, group = group,
                                         colour = group == "This district")) +
    ggplot2::geom_line(ggplot2::aes(linewidth = group == "This district")) +
    scale_color_f10("highlight", reverse = TRUE) +
    ggplot2::scale_linewidth_manual(values = c(0.6, 1.2)) +
    f10_annotate(x = 2025.1, y = 63, label = "This district", valence = "positive") +
    f10_annotate(x = 2025.1, y = 53, label = "State", valence = "neutral") +
    f10_annotate(x = 2025.1, y = 55.5, label = "Peer districts", valence = "neutral") +
    ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0.02, 0.25))) +
    ggplot2::labs(
      title = "This district pulled ahead of state and peer averages after 2023",
      subtitle = "Percent proficient, 2021-2025",
      x = NULL, y = "Percent proficient"
    ) +
    theme_foundry10(grid = "y")

  message("theme_foundry10 self-test built 3 plots using font: ", f10_font())
  invisible(list(highlight_bar = p1, likert = p2, line = p3))
}
