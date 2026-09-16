# =============================================================================
# theme_foundry10.R
#
# foundry10 brand colours and a ggplot2 theme.
#
# Rules and the reasoning behind them: docs/visual-style.md
# Source: foundry10 Visual Style Guide v5.0 (Feb 2025), pp. 9-21
# =============================================================================

# --- Colours -----------------------------------------------------------------
#
# The same colour is set for LaTeX headings in reports/zero_order_report.qmd.
# Change both together.

f10_orange <- "#D14E1D"
f10_cyan <- "#01646F"
f10_black <- "#111111"
f10_paper <- "#F9F9F9"

f10_text_orange <- "#CA4A1C" # orange that is legible below 14pt on white
f10_cyan_bright <- "#078B9C"
f10_cyan_dark <- "#0E2528"
f10_orange_light <- "#F9A65F"

f10_gray_dark <- "#575857"
f10_gray_mid <- "#939598"
f10_gray_light <- "#E2E3E4"
f10_gray_pale <- "#F2F2F2"

# Tints, for grouping related response options.
f10_cyan_tints <- c("#01646F", "#326A72", "#AEC4C6", "#E0ECED")
f10_orange_tints <- c("#D14E1D", "#D96F50", "#EBC5B9", "#F4E6E2")

# Helvetica Neue is the brand face; Arial is the guide's own fallback.
f10_font <- if ("Helvetica Neue" %in% systemfonts::system_fonts()$family) {
  "Helvetica Neue"
} else {
  "Arial"
}


# --- Theme -------------------------------------------------------------------
# base_size stays at or above 9 -- the guide's print minimum. Anything that
# would shrink text below that should shrink the figure instead.

theme_foundry10 <- function(base_size = 10, base_family = f10_font) {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      text = ggplot2::element_text(colour = f10_black),
      plot.title = ggplot2::element_text(
        size = ggplot2::rel(1.5), # headings 150% of body, per the guide
        face = "bold",
        colour = f10_black,
        hjust = 0,
        margin = ggplot2::margin(b = 4)
      ),
      plot.subtitle = ggplot2::element_text(
        size = ggplot2::rel(1),
        colour = f10_gray_dark,
        hjust = 0,
        margin = ggplot2::margin(b = 8)
      ),
      plot.caption = ggplot2::element_text(
        size = ggplot2::rel(0.9),
        colour = f10_gray_dark,
        hjust = 0,
        margin = ggplot2::margin(t = 8)
      ),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      axis.text = ggplot2::element_text(
        colour = f10_black,
        size = ggplot2::rel(0.95)
      ),
      axis.title = ggplot2::element_text(
        colour = f10_gray_dark,
        size = ggplot2::rel(0.95)
      ),
      # Secondary elements go light, so the estimates carry the attention.
      panel.grid.major = ggplot2::element_line(
        colour = f10_gray_light,
        linewidth = 0.3
      ),
      panel.grid.minor = ggplot2::element_blank(),
      panel.background = ggplot2::element_blank(),
      plot.background = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      strip.text = ggplot2::element_text(
        colour = f10_black,
        face = "bold",
        size = ggplot2::rel(0.95),
        hjust = 0,
        margin = ggplot2::margin(t = 6, b = 3)
      ),
      strip.background = ggplot2::element_blank(),
      legend.position = "none", # position encodes the category; colour is reserved
      plot.margin = ggplot2::margin(6, 10, 6, 6)
    )
}


# --- Discrete scales ---------------------------------------------------------
# Minimise the number of colours: these exist for the cases where a chart
# genuinely needs to key on colour, not for the dot-whisker figures, where the
# subgroup level is already encoded by position.

scale_colour_foundry10 <- function(...) {
  ggplot2::discrete_scale(
    "colour",
    palette = function(n) {
      if (n > length(f10_cyan_tints)) {
        stop(
          "foundry10 palette has ",
          length(f10_cyan_tints),
          " colours; ",
          n,
          " requested. Never repeat a colour in a key -- redesign the chart."
        )
      }
      f10_cyan_tints[seq_len(n)]
    },
    ...
  )
}

scale_fill_foundry10 <- function(...) {
  ggplot2::discrete_scale(
    "fill",
    palette = function(n) {
      if (n > length(f10_cyan_tints)) {
        stop(
          "foundry10 palette has ",
          length(f10_cyan_tints),
          " colours; ",
          n,
          " requested. Never repeat a colour in a key -- redesign the chart."
        )
      }
      f10_cyan_tints[seq_len(n)]
    },
    ...
  )
}
