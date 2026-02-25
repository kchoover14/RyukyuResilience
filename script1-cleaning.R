######################## LIBRARIES

library(readxl)    # import Excel files
library(dplyr)     # data wrangling
library(janitor)   # standardize column names


######################## DENTAL DATA

kanna    = read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Kanna",
                      na = c("ns", "", "?", "F?", "M?"))
nagabaka = read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Nagabaka",
                      na = c("ns", "", "?", "F?", "M?"))
yatchi   = read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Yatchi",
                      na = c("ns", "", "?", "F?", "M?"))

# Add site labels
kanna$site    = rep("Kanna",    nrow(kanna))
nagabaka$site = rep("Nagabaka", nrow(nagabaka))
yatchi$site   = rep("Yatchi",   nrow(yatchi))

# Standardize column names
kanna    = clean_names(kanna)
nagabaka = clean_names(nagabaka)
yatchi   = clean_names(yatchi)

# Merge
ryukyu = rbind(kanna, nagabaka, yatchi)

# Per-tooth averages for analytical variables
ryukyu = ryukyu |> mutate(hypoplasia_average = total_leh / total_no_teeth)
ryukyu = ryukyu |> mutate(calculus_average   = total_calculus / total_no_teeth)
ryukyu = ryukyu |> mutate(attrition_average  = total_attrition / total_no_teeth)

# Final dataset -- keep only analytical variables
ryukyu = ryukyu |> dplyr::select(site, burial, sex,
                                  hypoplasia_average, calculus_average, attrition_average)

write.csv(ryukyu, "data-ryukyu-dental.csv", row.names = FALSE, quote = FALSE)


######################## CRIBRA ORBITALIA DATA

kannaCO    = read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Kanna",
                        na = c("ns", "", "?", "F?", "M?"))
nagabakaCO = read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Nagabaka",
                        na = c("ns", "", "?", "F?", "M?"))
yatchiCO   = read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Yatchi",
                        na = c("ns", "", "?", "F?", "M?"))

# Standardize column names
kannaCO    = clean_names(kannaCO)
nagabakaCO = clean_names(nagabakaCO)
yatchiCO   = clean_names(yatchiCO)

# Align burial column name before merge
yatchiCO = rename(yatchiCO, burial = burial_jar)

# Add site labels
kannaCO$site    = rep("Kanna",    nrow(kannaCO))
nagabakaCO$site = rep("Nagabaka", nrow(nagabakaCO))
yatchiCO$site   = rep("Yatchi",   nrow(yatchiCO))

# Merge
ryukyuCO = rbind(kannaCO, nagabakaCO, yatchiCO)

write.csv(ryukyuCO, "data-ryukyu-CO.csv", row.names = FALSE, quote = FALSE)


######################## TIDY

rm(list = ls())
gc()
