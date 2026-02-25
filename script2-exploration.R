######################## LIBRARIES

library(dplyr)    # data wrangling
library(tidyr)    # pivot_longer
library(ggplot2)  # plots
library(skimr)    # descriptive statistics


######################## DATA

ryukyu   = read.csv("data-ryukyu-dental.csv", stringsAsFactors = TRUE)
ryukyuCO = read.csv("data-ryukyu-co.csv",     stringsAsFactors = TRUE)


######################## DENTAL -- DESCRIPTIVES

descriptives = ryukyu |>
  group_by(site, sex) |>
  summarise(
    n = n(),
    across(c(hypoplasia_average, calculus_average, attrition_average),
           list(mean   = ~mean(.,   na.rm = TRUE),
                sd     = ~sd(.,     na.rm = TRUE),
                median = ~median(., na.rm = TRUE),
                min    = ~min(.,    na.rm = TRUE),
                max    = ~max(.,    na.rm = TRUE)),
           .names = "{.col}_{.fn}")
  )

write.csv(descriptives, "descriptives.csv", row.names = FALSE)


######################## DENTAL -- DISTRIBUTION

# Wide to long for faceted plots
ryukyu_long = ryukyu |>
  pivot_longer(cols = c(hypoplasia_average, calculus_average, attrition_average),
               names_to  = "variable",
               values_to = "value") |>
  na.omit()

# Comprehensive summaries with skimr
skim(ryukyu)

ryukyu |>
  group_by(site) |>
  skim()

ryukyu |>
  group_by(site, sex) |>
  skim()

# QQ plot -- pooled (supplemental; title retained for repo context)
ggplot(ryukyu_long, aes(sample = value)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~variable, scales = "free") +
  theme_minimal() +
  labs(title = "QQ Plots -- Distribution Check")

ggsave("plot-distribution dental pooled.png",
       plot   = last_plot(),
       width  = 10,
       height = 6,
       dpi    = 300)

# QQ plot -- by site and sex (supplemental; title retained for repo context)
ggplot(ryukyu_long, aes(sample = value, color = sex, shape = sex)) +
  stat_qq() +
  stat_qq_line(color = "black") +
  facet_grid(site ~ variable, scales = "free") +
  labs(title = "QQ Plots -- Distribution Check by Site and Variable",
       x     = "Normal Distribution Quantiles",
       y     = "Sample Quantiles") +
  theme_classic() +
  theme(
    legend.position = "top",
    text            = element_text(size = 12, family = "TT Times New Roman"),
    axis.text.x     = element_text(color = "black", size = 12),
    axis.text.y     = element_text(color = "black", size = 12)
  ) +
  scale_colour_viridis_d(begin = 0.15, end = 0.65)

ggsave("plot-distribution dental by site and sex.png",
       plot   = last_plot(),
       width  = 10,
       height = 6,
       dpi    = 300)


######################## CRIBRA ORBITALIA -- DESCRIPTIVES

cat("\n=== CRIBRA ORBITALIA SEVERITY DISTRIBUTION ===\n")
table(ryukyuCO$cribra_total, useNA = "ifany")

cat("\n=== BY SITE ===\n")
table(ryukyuCO$site, ryukyuCO$cribra_total, useNA = "ifany")

cat("\n=== BY SEX ===\n")
table(ryukyuCO$sex, ryukyuCO$cribra_total, useNA = "ifany")

descriptivesCO = ryukyuCO |>
  group_by(site, sex) |>
  summarise(
    n = n(),
    across(cribra_total,
           list(mean   = ~mean(.,   na.rm = TRUE),
                sd     = ~sd(.,     na.rm = TRUE),
                median = ~median(., na.rm = TRUE),
                min    = ~min(.,    na.rm = TRUE),
                max    = ~max(.,    na.rm = TRUE)),
           .names = "{.col}_{.fn}")
  )

write.csv(descriptivesCO, "descriptivesCO.csv", row.names = FALSE)


######################## CRIBRA ORBITALIA -- DISTRIBUTION

# Distribution by site and sex (supplemental; title retained for repo context)
ggplot(ryukyuCO |> filter(!is.na(cribra_total)),
       aes(x = factor(cribra_total), fill = sex)) +
  geom_bar(position = "dodge") +
  facet_wrap(~site) +
  labs(title = "Cribra Orbitalia Severity Distribution by Site and Sex",
       x     = "Cribra Orbitalia Severity",
       y     = "Count") +
  scale_fill_viridis_d(begin = 0.15, end = 0.65) +
  theme_classic()

ggsave("plot-distribution co.png",
       plot   = last_plot(),
       width  = 10,
       height = 6,
       dpi    = 300)


######################## TIDY

rm(list = ls())
gc()
