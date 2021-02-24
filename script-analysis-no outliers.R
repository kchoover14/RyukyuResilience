options(prompt="R>")
options("scipen"=100, "digits"=3)

library(readxl)
library(broom)
library(ggplot2)
library(car)
library(fitdistrplus)
library(psych)

rk = read_excel("data-Ryukyu-analysis-KCH-15SEP20.xlsx", sheet = "three_sites")
rk$Site = factor(rk$Site)
rk$Sex = factor(rk$Sex)

rkco = read_excel("data-Ryukyu-analysis-KCH-15SEP20.xlsx", sheet = "co")
rkco$Site = factor(rkco$Site)
rkco$Sex = factor(rkco$Sex)

sink("rk-results.txt", append=FALSE)
#DATA SUMMARY
females = subset(rk, Sex == 'F')
femalesco = subset(rkco, Sex == 'F')
males = subset(rk, Sex == 'M')
malesco = subset(rkco, Sex == 'M')
Site1=factor(females$Site, levels = c("Yatchi", "Kanna", "Nagabaka"))
Site2=factor(males$Site, levels = c("Yatchi", "Kanna", "Nagabaka"))
Site3=factor(femalesco$Site, levels = c("Yatchi", "Kanna", "Nagabaka"))
Site4=factor(malesco$Site, levels = c("Yatchi", "Kanna", "Nagabaka"))

describeBy(rk, rk$Site)
describeBy(rkco, rkco$Site)
describeBy(females, females$Site)
describeBy(femalesco, femalesco$Site)
describeBy(males, males$Site)
describeBy(malesco, malesco$Site)

#INTER-SITE DIFFERENCES, FEMALE
hypofemale = glm(females$HypoFreq ~ Site1)
calcfemale = glm(females$CalcFreq ~ Site1)
attfemale = glm(females$AttAv ~ Site1)
cofemale = glm(femalesco$CO ~ Site3, family= binomial)

car::Anova(hypofemale)
glance(hypofemale)
car::Anova(calcfemale)
glance(calcfemale)
car::Anova(attfemale)
glance(attfemale)
car::Anova(cofemale)
glance(cofemale)

summary(hypofemale)
summary(calcfemale)
summary(attfemale)
summary(cofemale)

#INTER-SITE DIFFERENCES, MALE
hypomale = glm(males$HypoFreq ~ Site2)
calcmale = glm(males$CalcFreq ~ Site2)
attmale = glm(males$AttAv ~ Site2)
comale = glm(malesco$CO ~ Site4, family= binomial)

car::Anova(hypomale)
glance(hypomale)
car::Anova(calcmale)
glance(calcmale)
car::Anova(attmale)
glance(attmale)
car::Anova(comale)
glance(comale)

summary(hypomale)
summary(calcmale)
summary(attmale)
summary(comale)

sink()

#PLOTS
hypoplotfem = tidy(hypofemale, conf.int = TRUE)
hypoplotmale = tidy(hypomale, conf.int = TRUE)
h1=ggplot(hypoplotfem, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="FEMALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
h2=ggplot(hypoplotmale, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="MALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
tiff("f4-hypofreq model.tiff",  units="in", width=10, height=5, res=300)
gridExtra::grid.arrange(h1, h2, nrow=1)
dev.off()

calcplotfem = tidy(calcfemale, conf.int = TRUE)
calcplotmale = tidy(calcmale, conf.int = TRUE)
c1=ggplot(calcplotfem, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="FEMALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
c2=ggplot(calcplotmale, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="MALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
tiff("f5-calcfreq model.tiff",  units="in", width=10, height=5, res=300)
gridExtra::grid.arrange(c1, c2, nrow=1)
dev.off()

attplotfem = tidy(attfemale, conf.int = TRUE)
attplotmale = tidy(attmale, conf.int = TRUE)
a1= ggplot(attplotfem, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="FEMALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
a2= ggplot(attplotmale, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="MALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
tiff("f6-att av model.tiff",  units="in", width=10, height=5, res=300)
gridExtra::grid.arrange(a1, a2, nrow=1)
dev.off()

coplotfem = tidy(cofemale, conf.int = TRUE)
coplotmale = tidy(comale, conf.int = TRUE)
co1=ggplot(coplotfem, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="FEMALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
co2=ggplot(coplotmale, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="MALE", y="") +
  theme_classic()+
  theme(text=element_text(size=16, face= "bold", family="TT Times New Roman"),
        axis.text.x = element_text(color = "black", size = 14),
        axis.text.y = element_text(color = "black", size = 14))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Yatchi", "Kanna", "Nagabaka"))
tiff("f7-cofreq model.tiff",  units="in", width=10, height=5, res=300)
gridExtra::grid.arrange(co1, co2, nrow=1)
dev.off()

