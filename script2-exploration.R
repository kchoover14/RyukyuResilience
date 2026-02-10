library(dplyr)
library(tidyr)
library(ggplot2)
library(skimr)

################################# DATA
ryukyu <- read.csv("data-ryukyu-dental.csv", stringsAsFactors = TRUE)
ryukyuCO <- read.csv("data-ryukyu-co.csv", stringsAsFactors = TRUE)


################################# DENTAL
##### DESCRIPTIVES
descriptives <- ryukyu |>
  group_by(site, sex) |>
  summarise(
    n = n(),
    across(c(hypoplasia_average, calculus_average, attrition_average),
           list(mean = ~mean(., na.rm = TRUE),
                sd = ~sd(., na.rm = TRUE),
                median = ~median(., na.rm = TRUE),
                min = ~min(., na.rm = TRUE),
                max = ~max(., na.rm = TRUE)),
           .names = "{.col}_{.fn}")
  )

write.csv(descriptives, "descriptives.csv", row.names = FALSE)

##### wide to long
ryukyu_long <- ryukyu |>
  pivot_longer(cols = c(hypoplasia_average, calculus_average, attrition_average),
               names_to = "variable",
               values_to = "value") |>
  na.omit()

##### DISTRIBUTION
# comprehensive summary with skimr, pooled
skim(ryukyu)

# comprehensive summary with skimr, by site
ryukyu |>
  group_by(site) |>
  skim()

# comprehensive summary with skimr, by site and sex
ryukyu |>
  group_by(site, sex) |>
  skim()


##### VISUALIZE
# pooled values
ggplot(ryukyu_long, aes(sample = value)) +
  stat_qq() +
  stat_qq_line() +
  facet_wrap(~variable, scales = "free") +
  theme_minimal() +
  labs(title = "QQ Plots - Distribution Check")
ggsave(filename = "fig2-distribution dental pooled.png",
       plot = last_plot(),
       device = "png",
       width = 10,
       height = 6,
       units = "in",
       dpi = 300)

#  by sex and site
ggplot(ryukyu_long, aes(sample = value, color = sex, shape = sex)) +
  stat_qq() +
  stat_qq_line(color = "black") +
  facet_grid(site ~ variable, scales = "free") +
  labs(title = "QQ Plots - Distribution Check by site and Variable",
       x = "Normal Distribution Quantiles",
       y = "Sample Quantiles") +
  theme_classic() +
  theme(
    legend.position = "top",
    text = element_text(size = 12, family = "TT Times New Roman"),
    axis.text.x = element_text(color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12)
  ) +
  scale_colour_viridis_d(begin = 0.15, end = 0.65)
ggsave(filename = "figS1-distribution dental by site and sex.png",
       plot = last_plot(),
       device = "png",
       width = 10,
       height = 6,
       units = "in",
       dpi = 300)




################################# CRIBRA ORBITALIA
cat("\n=== CRIBRA ORBITALIA SEVERITY DISTRIBUTION ===\n")
table(ryukyuCO$cribra_total, useNA = "ifany")

# By site
cat("\n=== BY SITE ===\n")
table(ryukyuCO$site, ryukyuCO$cribra_total, useNA = "ifany")

# By sex
cat("\n=== BY SEX ===\n")
table(ryukyuCO$sex, ryukyuCO$cribra_total, useNA = "ifany")

# Descriptives
ryukyuCO |>
  group_by(site, sex) |>
  summarise(
    n = n(),
    n_missing = sum(is.na(cribra_total)),
    mean_severity = mean(cribra_total, na.rm = TRUE),
    median_severity = median(cribra_total, na.rm = TRUE),
    min_severity = min(cribra_total, na.rm = TRUE),
    max_severity = max(cribra_total, na.rm = TRUE)
  )

# Visualize distribution
ggplot(ryukyuCO |> filter(!is.na(cribra_total)),
       aes(x = factor(cribra_total), fill = sex)) +
  geom_bar(position = "dodge") +
  facet_wrap(~site) +
  labs(x = "Cribra Orbitalia Severity", y = "Count") +
  scale_fill_viridis_d(begin = 0.15, end = 0.65) +
  theme_classic()
ggsave(filename = "figS2-distribution co.png",
       plot = last_plot(),
       device = "png",
       width = 10,
       height = 6,
       units = "in",
       dpi = 300)

descriptivesCO <- ryukyuCO |>
  group_by(site, sex) |>
  summarise(
    n = n(),
    across(cribra_total,
           list(mean = ~mean(., na.rm = TRUE),
                sd = ~sd(., na.rm = TRUE),
                median = ~median(., na.rm = TRUE),
                min = ~min(., na.rm = TRUE),
                max = ~max(., na.rm = TRUE)),
           .names = "{.col}_{.fn}")
  )
write.csv(descriptivesCO, "descriptivesCO.csv", row.names = FALSE)

################################# TIDY
rm(list = ls())
gc()