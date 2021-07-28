library(readxl); library(tidyverse); library(data.table)

#source data: data-ryukyu-raw-cribra orbitalia-MJH (recorded on Japanese Excel version)
#individual sheets were saved as cvs to reduce character Japanese errors
kanna.co <- read.csv("data-ryukyu-raw-cribra orbitalia-kanna.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)
nagabaka.co <- read.csv("data-ryukyu-raw-cribra orbitalia-nagabaka.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)
yatchi.co <- read.csv("data-ryukyu-raw-cribra orbitalia-yatchi.csv", sep=",", strip.white = TRUE,
    na.strings = c("ns", "", '?', "F?", "M?"), check.names = TRUE)

#change yatchi burial column name and merge data
yatchi.co <- rename(yatchi.co, Burial=Burial.Jar)

#add new column with site name for each dataset
kanna.co$Site <- rep("Kanna",nrow(kanna.co))
nagabaka.co$Site <- rep("Nagabaka",nrow(nagabaka.co))
yatchi.co$Site <- rep("Yatchi",nrow(yatchi.co))

#merge
ryukyu.co <- rbind(kanna.co, nagabaka.co, yatchi.co)
rm(kanna.co, nagabaka.co, yatchi.co)

#clean text
ryukyu.co <- rename_with(ryukyu.co, tolower)

#save data
write.csv(ryukyu.co, "data-ryukyu-final-cribra orbitalia.csv", row.names = FALSE, quote=FALSE)

#tidy
rm(ryukyu.co)
gc()

