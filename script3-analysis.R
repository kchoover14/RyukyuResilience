library(dplyr)
library(ggplot2)
library(ggeffects)
library(broom)
library(cowplot)

################################# DATA
ryukyu <- read.csv("data-ryukyu-dental.csv", stringsAsFactors = TRUE)
ryukyuCO <- read.csv("data-ryukyu-co.csv", stringsAsFactors = TRUE)

# Relevel to use Yatchi as reference (for comparison)
ryukyu$site <- factor(ryukyu$site, levels = c("Yatchi", "Kanna", "Nagabaka"))
ryukyuCO$site <- factor(ryukyuCO$site, levels = c("Yatchi", "Kanna", "Nagabaka"))

################################# GLM MODELS DENTAL
# Dental health markers (Gaussian family for continuous averages/rates)
hypo_model <- glm(hypoplasia_average ~ site * sex,
                  data = ryukyu,
                  family = gaussian())

calc_model <- glm(calculus_average ~ site * sex,
                  data = ryukyu,
                  family = gaussian())

att_model <- glm(attrition_average ~ site * sex,
                 data = ryukyu,
                 family = gaussian())


################################# GLM MODELS CO
# severity scores are subjective
# 0 is fundamentally different than 1+ and levels for 1+ are not proportional distant from each other in terms of measure or impact from independent variables
#convert to binary
ryukyuCO <- ryukyuCO |>
  mutate(cribra_present = ifelse(cribra_total > 0, 1, 0))

co_model <- glm(cribra_present ~ site * sex,
                data = ryukyuCO,
                family = binomial())

################################# MODEL SUMMARIES

# Function to create tidy model output
tidy_model_output <- function(model, model_name) {
  cat("\n", rep("=", 80), "\n", sep = "")
  cat(model_name, "\n")
  cat(rep("=", 80), "\n", sep = "")

  # Model summary
  print(summary(model))

  # AIC
  cat("\nAIC:", AIC(model), "\n")

  # Confidence intervals
  cat("\nConfidence Intervals (95%):\n")
  print(confint(model))

  # Tidy output
  cat("\nTidy coefficients:\n")
  print(tidy(model, conf.int = TRUE))

  cat("\n")
}

# create output
tidy_model_output(hypo_model, "HYPOPLASIA MODEL")
tidy_model_output(calc_model, "CALCULUS MODEL")
tidy_model_output(att_model, "ATTRITION MODEL")
tidy_model_output(co_model, "CRIBRA ORBITALIA MODEL (Binomial)")



## Attrition model results had overdisperson, consider gamme
att_model_gamma <- glm(attrition_average ~ site * sex,
                       data = ryukyu,
                       family = Gamma(link = "log"))

tidy_model_output(att_model_gamma, "ATTRITION MODEL GAMMA") #better aic value

# save model output
model_results <- bind_rows(
  tidy(hypo_model, conf.int = TRUE) |> mutate(model = "Hypoplasia"),
  tidy(calc_model, conf.int = TRUE) |> mutate(model = "Calculus"),
  tidy(att_model_gamma, conf.int = TRUE) |> mutate(model = "Attrition GAMMA"),
  tidy(co_model, conf.int = TRUE) |> mutate(model = "Cribra Orbitalia")
)

#save model results
write.csv(model_results, "results-glm-coefficients.csv", row.names = FALSE)


################################# RESIDUALS PLOTS
png("figS3-diagnostics-all-models.png", width = 12, height = 12, units = "in", res = 300)
par(mfrow = c(4, 4))

plot(hypo_model, main = c("Hypoplasia", "", "", ""))
plot(calc_model, main = c("Calculus", "", "", ""))
plot(att_model_gamma, main = c("Attrition (Gamma)", "", "", ""))
plot(co_model, main = c("Cribra Orbitalia", "", "", ""))

dev.off()


################################# MARGINAL EFFECTS PLOTS
# Extract predictions for plotting
pred_hypo <- ggpredict(hypo_model, terms = c("site", "sex"))
pred_calc <- ggpredict(calc_model, terms = c("site", "sex"))
pred_att <- ggpredict(att_model_gamma, terms = c("site", "sex"))  # Changed to gamma
pred_co <- ggpredict(co_model, terms = c("site", "sex"))

# Create plots with consistent styling
plot_marginal <- function(predictions, y_label) {
  plot(predictions) +
    scale_colour_viridis_d(begin = 0.15, end = 0.65,
                           name = "", labels = c("Female", "Male")) +
    theme_classic() +
    labs(title = "", x = "", y = y_label) +
    theme(
      legend.position = "top",
      text = element_text(size = 12, family = "TT Times New Roman"),
      axis.text = element_text(color = "black", size = 11)
    )
}

p1 <- plot_marginal(pred_hypo, "Hypoplasia (average per tooth)")
p2 <- plot_marginal(pred_calc, "Calculus (average per tooth)")
p3 <- plot_marginal(pred_att, "Attrition (average)")
p4 <- plot_marginal(pred_co, "Cribra Orbitalia (presence)")

ggsave("fig3-marginal-effects.png",
       plot_grid(p1, p2, p3, p4, nrow = 2, ncol = 2, labels = "AUTO"),
       width = 10, height = 8, dpi = 300)


################################# TIDY
rm(list = ls())
gc()