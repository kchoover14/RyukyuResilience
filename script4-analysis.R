library(dplyr)
library(ggplot2); library(cowplot); library(ggpubr)
library(ggeffects); library(car)

#read data
ryukyu <- read.csv("data-ryukyu-final-dental.csv", stringsAsFactors = TRUE)
ryukyu.out <- read.csv("data-ryukyu-final-dental out.csv", stringsAsFactors = TRUE)
ryukyu.co <- read.csv("data-ryukyu-final-cribra orbitalia.csv", stringsAsFactors = TRUE)
#relevel to use Yatchi as comparison
ryukyu$site <- factor(ryukyu$site, levels = c("Yatchi", "Kanna", "Nagabaka"))
ryukyu.out$site <- factor(ryukyu.out$site, levels = c("Yatchi", "Kanna", "Nagabaka"))
ryukyu.co$site <- factor(ryukyu.co$site, levels = c("Yatchi", "Kanna", "Nagabaka"))
#filter by sex
females <- filter(ryukyu, sex == "F")
males <- filter(ryukyu, sex == "M")
females.co <- filter(ryukyu.co, sex == "F")
males.co <- filter(ryukyu.co, sex == "M")
#filter by site for models
kanna <- filter(ryukyu, site=="Kanna")
nagabaka <- filter(ryukyu, site=="Nagabaka")
yatchi <- filter(ryukyu, site=="Yatchi")
kanna.co <- filter(ryukyu.co, site=="Kanna")
nagabaka.co <- filter(ryukyu.co, site=="Nagabaka")
yatchi.co <- filter(ryukyu.co, site=="Yatchi")

#models
hypo.model=glm(hypoplasia.frequency ~ site + sex + site:sex, data=ryukyu)
hypo.model.out=glm(hypoplasia.frequency.out ~ site + sex + site:sex, data=ryukyu.out)
calc.model=glm(calculus.frequency ~ site + sex + site:sex, data=ryukyu)
calc.model.out=glm(calculus.frequency.out ~ site + sex + site:sex, data=ryukyu.out)
att.model=glm(attrition.average ~ site + sex + site:sex, data=ryukyu)
co.model=glm(cribra.total~ site + sex +site:sex, data=ryukyu.co)

#summary
sink("results-models.txt")
summary(hypo.model)
confint(hypo.model)

summary(hypo.model.out)
confint(hypo.model.out)

summary(calc.model)
confint(calc.model)

summary(calc.model.out)
confint(calc.model.out)

summary(att.model)
confint(att.model)

summary(co.model)
confint(co.model)
sink()

#Figure 3: Predicted Values (Marginal Effects)
pa <- ggpredict(hypo.model, terms = c("site", "sex"))
p1 <- plot(pa)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2()+
  labs(title="", x= "", y="Hypoplasia")+
  theme(legend.position = "top")

pa1 <- ggpredict(hypo.model.out, terms = c("site", "sex"))
p11 <- plot(pa1)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2()+
  labs(title="", x= "", y="Hypoplasia (no outlier)")+
  theme(legend.position = "top")

pb <- ggpredict(calc.model, terms = c("site", "sex"))
p2 <- plot(pb)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2() +
  labs(title="", x= "", y="Calculus")+
  theme(legend.position = "top")

pb1 <- ggpredict(calc.model.out, terms = c("site", "sex"))
p22 <- plot(pb1)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2() +
  labs(title="", x= "", y="Calculus (no outlier)")+
  theme(legend.position = "top")

pc <- ggpredict(att.model, terms = c("site", "sex"))
p3 <- plot(pc)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2() +
  labs(title="", x= "", y="Attrition")+
  theme(legend.position = "top")

pd <- ggpredict(co.model, terms = c("site", "sex"))
p4 <- plot(pd)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2()+
  labs(title="", x= "", y="Cribra Orbitalia")+
  theme(legend.position = "top")

png("f3-marginal efects.png",  units="in", width=8, height=5, res=300)
plot_grid(p1, p2, p4, p11, p22, p3, nrow=2)
dev.off()

