library(dplyr); library(ggplot2); library(cowplot)
library(car); library(fitdistrplus); library(psych)

#read data
ryukyu <- read.csv("data-ryukyu-final-dental.csv", stringsAsFactors = TRUE)
ryukyu.co <- read.csv("data-ryukyu-final-cribra orbitalia.csv", stringsAsFactors = TRUE)

#filter by site for descriptives
kanna <- filter(ryukyu, site=="Kanna")
nagabaka <- filter(ryukyu, site=="Nagabaka")
yatchi <- filter(ryukyu, site=="Yatchi")
kanna.co <- filter(ryukyu.co, site=="Kanna")
nagabaka.co <- filter(ryukyu.co, site=="Nagabaka")
yatchi.co <- filter(ryukyu.co, site=="Yatchi")

#plot distribution of data against normal plot
#there are long tails on either end, otherwise it fits normal
#use glm
qqp(ryukyu$hypoplasia.frequency, "norm", grid=FALSE, ylab=paste("Hypoplasia Frequency"),
  xlab=paste("Normal Distribution Quantiles"))
qqp(ryukyu$calculus.frequency, "norm", grid=FALSE, ylab=paste("Calculus Frequency"),
  xlab=paste("Normal Distribution Quantiles"))
qqp(ryukyu$attrition.average, "norm", grid=FALSE, ylab=paste("Average Attrition"),
  xlab=paste("Normal Distribution Quantiles"))

#summary
sink("descriptives.txt", type="output", append=FALSE)
describe(kanna, na.rm = TRUE)
describe(nagabaka, na.rm = TRUE)
describe(yatchi, na.rm = TRUE)
describe(kanna.co, na.rm = TRUE)
describe(nagabaka.co, na.rm = TRUE)
describe(yatchi.co, na.rm = TRUE)
describeBy(kanna, group="sex", na.rm = TRUE)
describeBy(nagabaka, group="sex", na.rm = TRUE)
describeBy(yatchi, group="sex",na.rm = TRUE)
describeBy(kanna.co, group="sex",na.rm = TRUE)
describeBy(nagabaka.co, group="sex",na.rm = TRUE)
describeBy(yatchi.co, group="sex",na.rm = TRUE)
sink()

#Figure 2: Data Distribution visualizations
v1 <- ggplot(na.omit(ryukyu), aes(hypoplasia.frequency, site, color = sex, shape=sex)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Hypoplasia Frequency", y="") +
  theme_classic2()+
  theme(legend.position = "top")+
  theme(text=element_text(size=12, family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12))+
  scale_colour_viridis_d(begin=.15, end=0.65)

v2 <- ggplot(na.omit(ryukyu), aes(calculus.frequency, site, color = sex, shape=sex)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Calculus Frequency", y="") +
  theme_classic2()+
  theme(legend.position = "top")+
  theme(text=element_text(size=12, family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12))+
  scale_colour_viridis_d(begin=.15, end=0.65)

v3 <- ggplot(na.omit(ryukyu), aes(attrition.average, site, color = sex, shape=sex)) +
  geom_jitter(width = .3, height = .3) +
  theme_classic2()+
  labs(title = "", x="Average Attrition", y="") +
  theme(text=element_text(size=12, family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "top") +
  scale_colour_viridis_d(begin=.15, end=0.65)

v4 <- ggplot(na.omit(ryukyu.co), aes(cribra.total, site, color = sex, shape=sex)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Cribra Orbitalia", y="") +
  theme_classic2()+
  theme(text=element_text(size=12, family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "top")+
  scale_colour_viridis_d(begin=.15, end=0.65)

png("f2-data visualization.png",  units="in", width=6, height=6, res=300)
plot_grid(v1, v2, v3, v4, nrow=2)
dev.off()

