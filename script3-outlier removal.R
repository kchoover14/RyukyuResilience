library(dplyr); library(ggplot2); library(cowplot)
library(car); library(fitdistrplus); library(psych)

#read data
ryukyu <- read.csv("data-ryukyu-final-dental.csv", stringsAsFactors = TRUE)

#filter by site for descriptives
kanna <- filter(ryukyu, site=="Kanna")
nagabaka <- filter(ryukyu, site=="Nagabaka")
yatchi <- filter(ryukyu, site=="Yatchi")

#add new columns without outliers
#find hypoplasia outlier
hypo.outliers <- boxplot(ryukyu$hypoplasia.frequency)$out
hypo.outliers
#remove hypoplasia outlier
ryukyu$hypoplasia.frequency.out <- replace(ryukyu$hypoplasia.frequency,
    ryukyu$hypoplasia.frequency > 1.5, NA)
#test hypoplasia outlier was removed
hypo.outliers2 <- boxplot(ryukyu$hypoplasia.frequency.out)$out
hypo.outliers2

#find calculus outlier
calc.outliers <- boxplot(ryukyu$calculus.frequency)$out
calc.outliers
#remove calculusoutlier
ryukyu$calculus.frequency.out <- replace(ryukyu$calculus.frequency,
    ryukyu$calculus.frequency > 1.5, NA)
#test calculus outlier was removed
calc.outliers2 <- boxplot(ryukyu$calculus.frequency.out)$out
calc.outliers2

#save data
write.csv(ryukyu, "data-ryukyu-final-dental out.csv")
