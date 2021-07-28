library(readxl); library(tidyverse); library(data.table)

#source data: data-raw-MJH (recorded on Japanese Excel version)
#individual sheets were saved as cvs to reduce character Japanese errors
kanna <- read.csv("data-ryukyu-raw-dental-kanna.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)
nagabaka <- read.csv("data-ryukyu-raw-dental-nagabaka.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)
yatchi <- read.csv("data-ryukyu-raw-dental-yatchi.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)

#remove lines that do not contain data
kanna <- anti_join(kanna,kanna[25:30,])
kanna <- anti_join(kanna,kanna[44:45,])
kanna <- anti_join(kanna,kanna[51,])

nagabaka <- anti_join(nagabaka,nagabaka[29:34,])
nagabaka <- anti_join(nagabaka,nagabaka[51,])
nagabaka <- anti_join(nagabaka,nagabaka[56:60,])

yatchi <- anti_join(yatchi,yatchi[25:28,])
yatchi <- anti_join(yatchi,yatchi[50,])

#add new column with site name for each dataset
kanna$Site <- rep("Kanna",nrow(kanna))
nagabaka$Site <- rep("Nagabaka",nrow(nagabaka))
yatchi$Site <- rep("Yatchi",nrow(yatchi))

#clean text
#rename yatchi column to remove extra /.
yatchi <- rename(yatchi, Molar.att..N.Molars = Molar.att...N.Molars)
#standarize column names
kanna  <- rename_with(kanna, ~ tolower(gsub("..", ".", .x, fixed = TRUE)))
nagabaka  <-  rename_with(nagabaka, ~ tolower(gsub("..", ".", .x, fixed = TRUE)))
yatchi  <-  rename_with(yatchi, ~ tolower(gsub("..", ".", .x, fixed = TRUE)))

#merge data
ryukyu <- rbind(kanna, nagabaka, yatchi)
rm(kanna, nagabaka, yatchi)
#remove duplicate column
ryukyu <- select(ryukyu, -no.molars.1)

#save cleaned data
write.csv(ryukyu, "data-ryukyu-clean-dental.csv", row.names = FALSE, quote=FALSE)
rm(ryukyu)
#read data so variables are read as numeric rather than convert
ryukyu <- read.csv("data-ryukyu-clean-dental.csv", stringsAsFactors = TRUE)

#remove individuals with only one tooth
ryukyu.oneplus <-  filter(ryukyu, total.no.teeth > "1")
rm(ryukyu)

#create new variables for analysis
ryukyu.oneplus <- ryukyu.oneplus %>% mutate(hypoplasia.frequency = (total.leh)/(total.no.teeth))
ryukyu.oneplus <- ryukyu.oneplus %>% mutate(calculus.frequency = (total.calculus/total.no.teeth))
ryukyu.oneplus <- ryukyu.oneplus %>% mutate(attrition.average = (total.attrition/total.no.teeth))
ryukyu.oneplus <- ryukyu.oneplus %>% arrange(site, burial)

#final dataset
ryukyu.final <- ryukyu.oneplus %>% dplyr::select(site, burial, sex, hypoplasia.frequency, calculus.frequency, attrition.average)
write.csv(ryukyu.final, "data-ryukyu-final-dental.csv", row.names = FALSE, quote=FALSE)

#tidy
rm(ryukyu.oneplus, ryukyu.final)
gc()

