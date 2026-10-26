#!/usr/bin/env Rscript
# plot_cm_class_by_genus.R
#
# Stacked bar plot of CM class distribution across viral genera,
# comparing 10 mM and 1 mM Mg conditions.
#
# Usage:
#   Rscript plot_cm_class_by_genus.R \
#       --tsv10  work/07_postproc/260602/best_stalls_10mM_sf0.2.tsv \
#       --tsv01  work/07_postproc/260602/best_stalls_01mM_sf0.2.tsv \
#       --out    work/07_postproc/260602/cm_class_by_genus.pdf
#
# Dependencies: ggplot2, dplyr, tidyr, optparse

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(optparse)
})

# ── CLI ───────────────────────────────────────────────────────────────────────
opt_list <- list(
  make_option("--tsv10", type = "character", help = "10 mM consolidated TSV"),
  make_option("--tsv01", type = "character", help = "1 mM consolidated TSV"),
  make_option("--out",   type = "character", default = "cm_class_by_genus.pdf",
              help = "Output PDF path [default: %default]"),
  make_option("--min-genus-n", type = "integer", default = 5,
              help = "Min total stalls for a genus to appear [default: %default]"),
  make_option("--width",  type = "double", default = 14, help = "Plot width (in)"),
  make_option("--height", type = "double", default = 6,  help = "Plot height (in)")
)
opts <- parse_args(OptionParser(option_list = opt_list))

if (is.null(opts$tsv10) || is.null(opts$tsv01)) {
  stop("Both --tsv10 and --tsv01 are required.")
}

# ── Load data ─────────────────────────────────────────────────────────────────
read_tsv_safe <- function(path, condition) {
  df <- read.delim(path, stringsAsFactors = FALSE)
  df$condition <- condition
  df
}

d10 <- read_tsv_safe(opts$tsv10, "10 mM Mg")
d01 <- read_tsv_safe(opts$tsv01, "1 mM Mg")
dat <- bind_rows(d10, d01)

# ── Tidy genus / cm_class ─────────────────────────────────────────────────────
dat <- dat %>%
  mutate(
    genus = ifelse(is.na(genus) | genus == "", "Unclassified", genus),
    cm_class = factor(cm_class,
                      levels = c("cl1a", "cl1b", "cl2", "cl3",
                                 "dumbbell", "unannotated"),
                      labels = c("cl1a xrRNA", "cl1b xrRNA", "cl2 xrRNA",
                                 "cl3 xrRNA", "Dumbbell", "Unannotated"))
  )

# filter genera with too few total stalls (across both conditions)
genus_totals <- dat %>%
  count(genus) %>%
  filter(n >= opts$`min-genus-n`)

dat <- dat %>% filter(genus %in% genus_totals$genus)

# order genera by total stall count descending
genus_order <- dat %>%
  count(genus) %>%
  arrange(desc(n)) %>%
  pull(genus)

dat$genus <- factor(dat$genus, levels = genus_order)

# ── Summarise ─────────────────────────────────────────────────────────────────
summary_df <- dat %>%
  count(genus, cm_class, condition) %>%
  complete(genus, cm_class, condition, fill = list(n = 0))

# condition as ordered factor for side-by-side faceting
summary_df$condition <- factor(summary_df$condition,
                                levels = c("10 mM Mg", "1 mM Mg"))

# ── Palette ───────────────────────────────────────────────────────────────────
cm_colors <- c(
  "cl1a xrRNA"  = "#1A5FA8",   # deep blue
  "cl1b xrRNA"  = "#4EA8DE",   # mid blue
  "cl2 xrRNA"   = "#F4A11D",   # amber
  "cl3 xrRNA"   = "#D85A30",   # burnt orange
  "Dumbbell"    = "#5DAD6F",   # sage green
  "Unannotated" = "#C8C8C8"    # light grey
)

# ── Plot ──────────────────────────────────────────────────────────────────────
p <- ggplot(summary_df,
            aes(x = genus, y = n, fill = cm_class)) +
  geom_bar(stat = "identity", width = 0.75, colour = NA) +
  facet_wrap(~ condition, ncol = 2) +
  scale_fill_manual(values = cm_colors, name = "CM class") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.05))) +
  labs(
    title    = "Xrn1 stall sites by viral genus and CM class",
    subtitle = paste0("SF \u2265 0.2 | 10 mM vs 1 mM Mg"),
    x        = "Viral genus",
    y        = "Number of stall sites"
  ) +
  theme_classic(base_size = 12) +
  theme(
    axis.text.x      = element_text(angle = 40, hjust = 1, size = 10),
    strip.background = element_rect(fill = "#F0F0F0", colour = NA),
    strip.text       = element_text(face = "bold", size = 11),
    legend.position  = "right",
    legend.key.size  = unit(0.5, "cm"),
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(colour = "grey40", size = 10),
    panel.grid.major.y = element_line(colour = "grey90", linewidth = 0.3)
  )

# ── Save ──────────────────────────────────────────────────────────────────────
ggsave(opts$out, p,
       width  = opts$width,
       height = opts$height,
       device = "pdf")

message("Saved: ", opts$out)
