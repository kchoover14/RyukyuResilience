options(prompt="R>")
options("scipen"=100, "digits"=3)

library(readxl)
library(broom)
library(ggplot2)
library(car)
library(fitdistrplus)
rk= read_excel("data-Ryukyu-exploration-KCH-14SEP20.xlsx", sheet = "three_sites")
rk$Site = factor(rk$Site)
rk$Sex = factor(rk$Sex)

rkco = read_excel("data-Ryukyu-exploration-KCH-14SEP20.xlsx", sheet = "co")
rkco$Site = factor(rkco$Site)
rkco$Sex = factor(rkco$Sex)

#NORMAL
histfit
tiff("SF1a-norm-hypo.tiff",  units="in", width=5, height=5, res=300)
qqp(rk$HypoFreq, "norm", grid=FALSE, ylab=paste("Hypoplasia Frequency"),
      xlab=paste("Normal Distribution Quantiles"))
dev.off()

tiff("SF1b-norm-hypo.tiff",  units="in", width=5, height=5, res=300)
qqp(rk$CalcFreq, "norm", grid=FALSE, ylab=paste("Calculus Frequency"),
    xlab=paste("Normal Distribution Quantiles"))
dev.off()
hist(rk$CalcFreq, freq = TRUE, main="Histogram of observed data", xlab = "CalcFreq")

tiff("SF1c-norm-hypo.tiff",  units="in", width=5, height=5, res=300)
qqp(rk$AttAv, "norm", grid=FALSE, ylab=paste("Attrition"),
            xlab=paste("Normal Distribution Quantiles"))
dev.off()

shapiro.test(rk$HypoFreq)
shapiro.test(rk$CalcFreq)
shapiro.test(rk$AttAv)

#PLOTS, Exploring data
e1=ggplot(females, aes(HypoFreq, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Female Hypoplasia Frequency", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e2=ggplot(females, aes(CalcFreq, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Female Calculus Frequency", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e3=ggplot(females, aes(AttAv, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Female Average Attrition", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e4=ggplot(femalesco, aes(CO, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Female Cribra Orbitalia", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e5=ggplot(males, aes(HypoFreq, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Male Hypoplasia Frequency", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e6=ggplot(males, aes(CalcFreq, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Male Calculus Frequency", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e7=ggplot(males, aes(AttAv, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Male Average Attrition", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

e8=ggplot(malesco, aes(CO, Site, color = Site)) +
  geom_jitter(width = .3, height = .3) +
  labs(title = "", x="Male Cribra Orbitalia", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")

tiff("f3-data exploration-outliers.tiff",  units="in", width=18, height=10, res=300)
gridExtra::grid.arrange(e1, e2, e3, e4, e5, e6, e7, e8, nrow=2)
dev.off()

