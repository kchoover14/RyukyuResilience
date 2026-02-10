library(dplyr); library(janitor)

################################# DENTAL DATA
kanna = readxl::read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Kanna",
                    na = c("ns", "", "?", "F?", "M?"))
nagabaka = readxl::read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Nagabaka",
                       na = c("ns", "", "?", "F?", "M?"))
yatchi = readxl::read_excel("data-ryukyu-raw-dental-kch.xlsx", sheet = "Yatchi",
                     na = c("ns", "", "?", "F?", "M?"))

# Add new column with site name for each dataset
kanna$site = rep("Kanna", nrow(kanna))
nagabaka$site = rep("Nagabaka", nrow(nagabaka))
yatchi$site = rep("Yatchi", nrow(yatchi))

# clean names
kanna = clean_names(kanna)
nagabaka = clean_names(nagabaka)
yatchi = clean_names(yatchi)

############# CLEAN TEXT
ryukyu = rbind(kanna, nagabaka, yatchi)

############# ANALYTICAL VARIABLES
# Create new variables for analysis
ryukyu = ryukyu |> mutate(hypoplasia_average = (total_leh)/(total_no_teeth))
ryukyu = ryukyu |> mutate(calculus_average = (total_calculus/total_no_teeth))
ryukyu = ryukyu |> mutate(attrition_average = (total_attrition/total_no_teeth))

# Final dataset
ryukyu = ryukyu |> dplyr::select(site, burial, sex, hypoplasia_average, calculus_average, attrition_average)
write.csv(ryukyu, "data-ryukyu-dental.csv", row.names = FALSE, quote = FALSE)







################################# CRIBRA ORBITALIA DATA
kannaCO= readxl::read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Kanna",
                           na = c("ns", "", "?", "F?", "M?"))
nagabakaCO = readxl::read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Nagabaka",
                              na = c("ns", "", "?", "F?", "M?"))
yatchiCO = readxl::read_excel("data-ryukyu-raw-co-kch.xlsx", sheet = "Yatchi",
                            na = c("ns", "", "?", "F?", "M?"))

# clean names
kannaCO = clean_names(kannaCO)
nagabakaCO = clean_names(nagabakaCO)
yatchiCO = clean_names(yatchiCO)

#change yatchi burial column name and merge data
yatchiCO = rename(yatchiCO, burial=burial_jar)

#add new column with site name for each dataset
kannaCO$site = rep("Kanna",nrow(kannaCO))
nagabakaCO$site = rep("Nagabaka",nrow(nagabakaCO))
yatchiCO$site = rep("Yatchi",nrow(yatchiCO))

#merge
ryukyuCO = rbind(kannaCO, nagabakaCO, yatchiCO)

#save data
write.csv(ryukyuCO, "data-ryukyu-CO.csv", row.names = FALSE, quote=FALSE)


################################# TIDY
rm(list = ls())
gc()

