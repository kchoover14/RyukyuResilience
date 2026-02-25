######################## LIBRARIES

library(dplyr)      # data wrangling
library(ggplot2)    # plots
library(ggeffects)  # marginal effects from GLM
library(broom)      # tidy model output
library(cowplot)    # arrange multi-panel figures


######################## DATA

ryukyu   = read.csv("data-ryukyu-dental.csv", stringsAsFactors = TRUE)
ryukyuCO = read.csv("data-ryukyu-co.csv",     stringsAsFactors = TRUE)

# Relevel to use Yatchi as reference site
ryukyu$site   = factor(ryukyu$site,   levels = c("Yatchi", "Kanna", "Nagabaka"))
ryukyuCO$site = factor(ryukyuCO$site, levels = c("Yatchi", "Kanna", "Nagabaka"))


######################## GLM MODELS -- DENTAL

# Gaussian family for continuous averages
hypo_model = glm(hypoplasia_average ~ site * sex, data = ryukyu,   family = gaussian())
calc_model = glm(calculus_average   ~ site * sex, data = ryukyu,   family = gaussian())
att_model  = glm(attrition_average  ~ site * sex, data = ryukyu,   family = gaussian())


######################## GLM MODELS -- CRIBRA ORBITALIA

# Convert severity score to binary presence/absence
# 0 is fundamentally different from 1+; severity levels are not proportionally scaled
ryukyuCO = ryukyuCO |>
  mutate(cribra_present = ifelse(cribra_total > 0, 1, 0))

co_model = glm(cribra_present ~ site * sex, data = ryukyuCO, family = binomial())


######################## MODEL SUMMARIES

# Function to print tidy model output
tidy_model_output = function(model, model_name) {
  cat("\n", rep("=", 80), "\n", sep = "")
  cat(model_name, "\n")
  cat(rep("=", 80), "\n", sep = "")
  print(summary(model))
  cat("\nAIC:", AIC(model), "\n")
  cat("\nConfidence Intervals (95%):\n")
  print(confint(model))
  cat("\nTidy coefficients:\n")
  print(tidy(model, conf.int = TRUE))
  cat("\n")
}

tidy_model_output(hypo_model, "HYPOPLASIA MODEL")
tidy_model_output(calc_model, "CALCULUS MODEL")
tidy_model_output(att_model,  "ATTRITION MODEL")
tidy_model_output(co_model,   "CRIBRA ORBITALIA MODEL (Binomial)")


######################## ATTRITION -- GAMMA REFIT

# Attrition model showed overdispersion with Gaussian family
# Gamma(link = "log") produces better AIC and handles right skew
att_model_gamma = glm(attrition_average ~ site * sex,
                      data   = ryukyu,
                      family = Gamma(link = "log"))

tidy_model_output(att_model_gamma, "ATTRITION MODEL -- GAMMA REFIT")


######################## EXPORT MODEL RESULTS

model_results = bind_rows(
  tidy(hypo_model,      conf.int = TRUE) |> mutate(model = "Hypoplasia"),
  tidy(calc_model,      conf.int = TRUE) |> mutate(model = "Calculus"),
  tidy(att_model_gamma, conf.int = TRUE) |> mutate(model = "Attrition (Gamma)"),
  tidy(co_model,        conf.int = TRUE) |> mutate(model = "Cribra Orbitalia")
)

write.csv(model_results, "results-glm-coefficients.csv", row.names = FALSE)


######################## RESIDUAL DIAGNOSTIC PLOTS

# Supplemental figure -- titles retained for repo context
png("plot-diagnostics-all-models.png", width = 12, height = 12, units = "in", res = 300)
par(mfrow = c(4, 4))
plot(hypo_model,      main = c("Hypoplasia",         "", "", ""))
plot(calc_model,      main = c("Calculus",            "", "", ""))
plot(att_model_gamma, main = c("Attrition (Gamma)",   "", "", ""))
plot(co_model,        main = c("Cribra Orbitalia",    "", "", ""))
dev.off()


######################## MARGINAL EFFECTS FIGURE

# Extract predicted values with 95% CI from each model
pred_hypo = ggpredict(hypo_model,      terms = c("site", "sex"))
pred_calc = ggpredict(calc_model,      terms = c("site", "sex"))
pred_att  = ggpredict(att_model_gamma, terms = c("site", "sex"))
pred_co   = ggpredict(co_model,        terms = c("site", "sex"))

# Consistent styling function -- no title (caption handled in QMD)
plot_marginal = function(predictions, y_label) {
  plot(predictions) +
    scale_colour_viridis_d(begin = 0.15, end = 0.65,
                           name = "", labels = c("Female", "Male")) +
    theme_classic() +
    labs(x = "", y = y_label) +
    theme(
      legend.position = "top",
      text            = element_text(size = 12, family = "TT Times New Roman"),
      axis.text       = element_text(color = "black", size = 11)
    )
}

p1 = plot_marginal(pred_hypo, "Hypoplasia (average per tooth)")
p2 = plot_marginal(pred_calc, "Calculus (average per tooth)")
p3 = plot_marginal(pred_att,  "Attrition (average)")
p4 = plot_marginal(pred_co,   "Cribra Orbitalia (presence)")

# labels = "AUTO" adds A, B, C, D panel labels
ggsave("plot-marginal-effects.png",
       plot_grid(p1, p2, p3, p4, nrow = 2, ncol = 2, labels = "AUTO"),
       width  = 10,
       height = 8,
       dpi    = 300)


######################## TIDY

rm(list = ls())
gc()
