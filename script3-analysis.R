library(dplyr); library(broom)
library(ggplot2); library(cowplot); library(ggpubr)
library(ggeffects); library(car)

#read data
ryukyu <- read.csv("data-ryukyu-final-dental.csv", stringsAsFactors = TRUE)
ryukyu.co <- read.csv("data-ryukyu-final-cribra orbitalia.csv", stringsAsFactors = TRUE)
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
calc.model=glm(calculus.frequency ~ site + sex + site:sex, data=ryukyu)
att.model=glm(attrition.average ~ site + sex + site:sex, data=ryukyu)
co.model=glm(cribra.total~ site + sex +site:sex, data=ryukyu.co)

#tidy summary
tidy(hypo.model, conf.int = TRUE)
tidy(calc.model, conf.int = TRUE)
tidy(att.model, conf.int = TRUE)
tidy(co.model, conf.int = TRUE)

#Figure 3: Predicted Values (Marginal Effects)
pa <- ggpredict(hypo.model, terms = c("site", "sex"))
p1 <- plot(pa)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2()+
  labs(title="", x= "", y="Hypoplasia")+
  theme(legend.position = "top")

pb <- ggpredict(calc.model, terms = c("site", "sex"))
p2 <- plot(pb)+
  scale_colour_viridis_d(begin=.15, end=0.65, name="", labels = c("Female", "Male"))+
  theme_classic2() +
  labs(title="", x= "", y="Calculus")+
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

png("f3-marginal efects.png",  units="in", width=5, height=5, res=300)
plot_grid(p1, p2, p3, p4, nrow=2)
dev.off()


## NOT USED
#Figure 3: Model Plots
hypo.tidy = tidy(hypo.model, conf.int = TRUE)
m1 = ggplot(hypo.tidy, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="Site", y="Hypoplasia") +
  theme(text=element_text(size=12, family="TT Times New Roman"),
    axis.text.x = element_text(color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Intercept", "Sex", "Kanna:Nagabaka",
    'Kanna:Nagabaka by Sex', "Kanna:Yatchi", 'Kanna:Yatchi by Sex'))+
  ylab("")+
  xlab("Hypoplasia")+
  scale_colour_viridis_d()+
  xlim(-.5, .5)+
  coord_flip()+
  theme_classic2()+
  theme(axis.text.x = element_text(angle = 45,vjust=1, hjust=1)) +
  theme(legend.position = "none")

calc.tidy = tidy(calc.model, conf.int = TRUE)
m2 = ggplot(calc.tidy, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="Site", y="Calculus") +
  theme(text=element_text(size=12, family="TT Times New Roman"),
    axis.text.x = element_text(color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Intercept", "Sex", "Kanna:Nagabaka",
    'Kanna:Nagabaka by Sex', "Kanna:Yatchi", 'Kanna:Yatchi by Sex'))+
  ylab("")+
  xlab("Calculus")+
  scale_colour_viridis_d()+
  coord_flip()+
  theme_classic2()+
  theme(axis.text.x = element_text(angle = 45,vjust=1, hjust=1))+
  theme(legend.position = "none")

att.tidy = tidy(att.model, conf.int = TRUE)
m3 = ggplot(att.tidy, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="Site", y="Attrition") +
  theme(text=element_text(size=12, family="TT Times New Roman"),
    axis.text.x = element_text(color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Intercept", "Sex", "Kanna:Nagabaka",
    'Kanna:Nagabaka by Sex', "Kanna:Yatchi", 'Kanna:Yatchi by Sex'))+
  ylab("")+
  xlab("Attrition")+
  scale_colour_viridis_d()+
  coord_flip()+
  theme_classic2()+
  theme(axis.text.x = element_text(angle = 45,vjust=1, hjust=1))+
  theme(legend.position = "none")

co.tidy = tidy(co.model, conf.int = TRUE)
m4 = ggplot(co.tidy, aes(estimate, term, color = term)) +
  geom_point() +
  geom_errorbarh(aes(xmin = conf.low, xmax = conf.high))+
  labs(title = "", x="Site", y="Cribra Orbitalia") +
  theme(text=element_text(size=12, family="TT Times New Roman"),
    axis.text.x = element_text(color = "black", size = 12),
    axis.text.y = element_text(color = "black", size = 12))+
  theme(legend.position = "none")+
  scale_y_discrete(labels = c("Intercept", "Sex", "Kanna:Nagabaka",
    'Kanna:Nagabaka by Sex', "Kanna:Yatchi", 'Kanna:Yatchi by Sex'))+
  ylab("")+
  xlab("Criba Orbitalia")+
  scale_colour_viridis_d()+
  xlim(-2, 2)+
  coord_flip()+
  theme_classic2()+
  theme(axis.text.x = element_text(angle = 45,vjust=1, hjust=1))+
  theme(legend.position = "none")

png("f-not used-models.png",  units="in", width=10, height=10, res=300)
plot_grid(m1, m2, m3, m4, nrow=2)
dev.off()

