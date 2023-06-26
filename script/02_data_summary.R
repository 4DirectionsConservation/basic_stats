# Session Info --------------------------------------------------------------

sessionInfo()
# R version 4.3.0 (2023-04-21 ucrt)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 11 x64 (build 22621)
# 
# Matrix products: default
# 
# 
# locale:
# [1] LC_COLLATE=English_Canada.utf8  LC_CTYPE=English_Canada.utf8   
# [3] LC_MONETARY=English_Canada.utf8 LC_NUMERIC=C                   
# [5] LC_TIME=English_Canada.utf8    
# 
# time zone: America/New_York
# tzcode source: internal
# 
# attached base packages:
# [1] stats     graphics  grDevices utils     datasets  methods   base     
# 
# other attached packages:
# [1] patchwork_1.1.2 vegan_2.6-4     lattice_0.21-8  permute_0.9-7   lubridate_1.9.2
# [6] forcats_1.0.0   stringr_1.5.0   dplyr_1.1.2     purrr_1.0.1     readr_2.1.4    
# [11] tidyr_1.3.0     tibble_3.2.1    ggplot2_3.4.2   tidyverse_2.0.0
# 
# loaded via a namespace (and not attached):
# [1] Matrix_1.5-4     gtable_0.3.3     compiler_4.3.0   renv_0.17.3      tidyselect_1.2.0
# [6] parallel_4.3.0   cluster_2.1.4    splines_4.3.0    scales_1.2.1     R6_2.5.1        
# [11] generics_0.1.3   MASS_7.3-58.4    munsell_0.5.0    pillar_1.9.0     tzdb_0.4.0      
# [16] rlang_1.1.1      utf8_1.2.3       stringi_1.7.12   timechange_0.2.0 cli_3.6.1       
# [21] mgcv_1.8-42      withr_2.5.0      magrittr_2.0.3   grid_4.3.0       rstudioapi_0.14 
# [26] hms_1.1.3        nlme_3.1-162     lifecycle_1.0.3  vctrs_0.6.3      glue_1.6.2      
# [31] fansi_1.0.4      colorspace_2.1-0 tools_4.3.0      pkgconfig_2.0.3 



# Libraries ---------------------------------------------------------------

library(tidyverse) # ddpylr, pipes, ggplot
library(vegan) # community data/community ecology, diversity analyses
# https://peat-clark.github.io/BIO381/veganTutorial.html 
library(patchwork) # for putting together figures
library(plotrix) # st. error function
library(car) # Anova function for sums of squares

# Data --------------------------------------------------------------------

invert_data <- read.csv("data/invert_data.csv")
str(invert_data)
colnames(invert_data)


# Make into Univariate Dataframe ----------------------------------------------

invert_data <- invert_data %>% 
  separate(site, c('site', 'sample')) #separate "site" and "sample" into separate columns

invert <- invert_data %>% select(Nemata:Unionidae) # just the invert data
env <- invert_data %>% select(site:sample) # the 'environmental data'


# Calculate measures of diversity

richness <- vegan::specnumber(invert) # how many species at each site/sample
abundance <- rowSums(invert) # abundance/summary of individuals at each site

# Shannon-Weiner Diversity
# use '?diversity' to learn about the function
#  H = -sum p_i log(b) p_i
# where p_i is the proportional abundance of species i and b is the base of the logarithm

H <- vegan::diversity(invert, index = "shannon")

# Simpsons diversity
# Simpson's index are based on D = sum p_i^2. Choice simpson returns 1-D 
D <- vegan::diversity(invert, index = 'simpson')

# Pielou's Eveness
# J' = H'/H'max aka H' = shannon diversity index and H'max = max possible value of H'
J <- H/log(richness)

### Create a univariate dataframe using the above data

univariate <- env # 'univariate' is the new name, put the 'env' data in

univariate$richness <- richness 
univariate$abundance <- abundance
univariate$shannon <- H
univariate$simpson <- D
univariate$evenness <- J

str(univariate)

# output as csv to save it so you can just call it in next time

write.csv(univariate, 'data/univariate_invert.csv')


# Descriptive Stats/Exploration -------------------------------------------

# Histogram of abundance
hist(univariate$abundance)
hist(univariate$richness)

## Summary Table

# summary table -----------------------------------------------------------

univariate_table <- univariate %>% group_by(site) %>% 
  summarise(across(
    .cols = where(is.numeric),
    .fns = list(Mean = mean, SD = sd, SE = std.error), na.rm = TRUE,
    .names = "{col}_{fn}"
  ))

# transpose it (t)
univariate_table <- univariate_table %>% t %>% as.data.frame

# V1         V2         V3
# site             station1   station2   station3
# richness_Mean    5.333333   3.666667   5.333333
# richness_SD     0.5773503  1.5275252  1.5275252
# richness_SE     0.3333333  0.8819171  0.8819171
# abundance_Mean   40.00000   20.00000   63.33333
# abundance_SD     9.539392  26.851443  16.196707
# abundance_SE     5.507571  15.502688   9.351173
# shannon_Mean     1.242957   1.120620   1.310140
# shannon_SD      0.1712102  0.5389593  0.3771780
# shannon_SE     0.09884827 0.31116828 0.21776380
# simpson_Mean    0.6237996  0.6068269  0.6788509
# simpson_SD      0.1161854  0.2483995  0.1117667
# simpson_SE     0.06707969 0.14341350 0.06452855
# evenness_Mean   0.7500362  0.8794997  0.7911290
# evenness_SD     0.1433745  0.1426944  0.1394131
# evenness_SE    0.08277731 0.08238468 0.08049020

# export as csv, use for reports

write.csv(univariate_table, 'data/invert_summary_table.csv')

# scaling up --------------------------------------------------------------

# samples were collected using a dredge net 0.1 m2
invert1 <- invert_data %>% select(Nemata:Unionidae)

# multiplied by 10 to make it 1m2
invert_1m <- invert1*10

richness_1m <- specnumber(invert_1m)
abundance_1m <- rowSums(invert_1m)

# Simpsons index 
# Simpson's index are based on D = sum p_i^2. Choice simpson returns 1-D 
simpson_1m <- diversity(invert_1m, index = "simpson")

# Shannon-Weiner diversity
#  H = -sum p_i log(b) p_i
# where p_i is the proportional abundance of species i and b is the base of the logarith
shannon_1m <- diversity(invert_1m, index = "shannon")

# Pielous evenness 
# J' = H'/H'max aka H' = shannon diversity index and H'max = max possible value of H'
pielous_1m <- shannon_1m/ log(specnumber(invert_1m)) 


univariate_1m <- env
univariate_1m$richness <- richness_1m
univariate_1m$abundance <- abundance_1m
univariate_1m$shannon <- shannon_1m
univariate_1m$simpson <- simpson_1m
univariate_1m$pielous <- pielous_1m

write.csv(univariate_1m, "output/univariate_1m.csv", row.names = TRUE)



univariate_table_1m <- univariate_1m %>% group_by(site) %>% 
  summarise(across(
    .cols = where(is.numeric),
    .fns = list(Mean = mean, SD = sd, SE = std.error), na.rm = TRUE,
    .names = "{col}_{fn}"
  ))

univariate_table_1m <- univariate_table_1m %>% t %>% as.data.frame

write.csv(univariate_table_1m, 
          "output/univariate_summary_1m.csv", row.names = TRUE)



# Univariate figures ------------------------------------------------------
# If you are picking up here to make edits etc. later, just import the data
# don't remake it every time
univariate <- read.csv("output/univariate_1m.csv")



### anovas, analysis of variance
# http://ecologyandevolution.org/statsdocs/online-stats-manual-chapter2.html

# is there a difference in abundance among the three sites?
density_aov <- lm(abundance ~ site, data = univariate)
Anova(density_aov)

# Response: abundance
#            Sum Sq Df F value  Pr(>F)  
# site      282222  2  3.9404 0.08076 .
# Residuals 214867  6   


# Invertebrate abundace was not significantly different among the sites (one-way ANOVA (F = 3.940, df = 2,6, p = 0.08)).
# also report the means and standard error from the tables, present a figure

richness_aov <- lm(richness ~ site, data = univariate)
Anova(richness_aov)

# Anova Table (Type II tests)
# 
# Response: richness
#             Sum Sq Df F value Pr(>F)
# site       5.5556  2  1.6667 0.2657
# Residuals 10.0000  6  

# Invertebrate richenss was not significantly different among the sites (one-way ANOVA (F = 1.667, df = 2,6, p = 0.27)).
# also report the means and standard error from the tables, present a figure


simpson_aov <- lm(simpson ~ site, data = univariate)
Anova(simpson_aov)

# Anova Table (Type II tests)
# 
# Response: simpson
# Sum Sq Df F value Pr(>F)
# site      0.008506  2  0.1455 0.8676
# Residuals 0.175386  6 




shannon_aov <- lm(shannon ~ site, data = univariate)
Anova(shannon_aov)

# Response: shannon
# Sum Sq Df F value Pr(>F)
# site      0.05540  2  0.1798 0.8397
# Residuals 0.92411  6

pielous_aov <- lm(pielous ~ site, data = univariate)
Anova(pielous_aov)

# Anova Table (Type II tests)
# 
# Response: pielous
# Sum Sq Df F value Pr(>F)
# site      0.026259  2  0.6526 0.5541
# Residuals 0.120708  6 


# Figures -----------------------------------------------------------------

## Invertebrate richness figure
# using ggplot (from tidyverse)
# https://r-graph-gallery.com/

richness1 <- ggplot(univariate, aes(x = site, y = richness)) + # call on data, x & y variables
  geom_boxplot(lwd=1) + #boxplot, lwd = line width
  geom_jitter(aes(shape = site, fill = site),
              size = 5, stroke = 1.5, width = 0.05, height = 0.05) + # jittered points overlay
  theme_classic(14) + #background colour etc. of figure
  labs(x = " ",
       y = "Taxa Richness") + # x and y labels
  scale_fill_manual(values = c("#BA251E","#F2C73B", "#48484B")) + # colour of points
  #scale_colour_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  theme(panel.border = element_rect(fill = NA)) + # add border around figure
  scale_shape_manual(values = c(21, 24, 22)) + # set the shapes of the points
  theme(legend.position = "none") + # no legend needed
  ylim(0,10) + # set the y axis limites
  scale_x_discrete(labels = c("station1" = "Station 1",
                              "station2" = "Station 2",
                              "station3" = "Station 3")) # change the x axis tick names




abundance <- ggplot(univariate, aes(x = site, y = abundance)) +
  geom_boxplot(lwd=1) +
  geom_jitter(aes(shape = site, fill = site),
              size = 5, stroke = 1.5, width = 0.05, height = 0.05) +
  theme_classic(14) +
  labs(x = " ",
       y = (expression(paste("Density per 1"," ", m^2)))) +
  scale_fill_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  scale_colour_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  theme(panel.border = element_rect(fill = NA)) +
  scale_shape_manual(values = c(21, 24, 22)) +
  theme(legend.position = "none") +
  ylim(0, 1000) +
  scale_x_discrete(labels = c("station1" = "Station 1",
                              "station2" = "Station 2",
                              "station3" = "Station 3"))

simpson <- ggplot(univariate, aes(x = site, y = simpson)) +
  geom_boxplot(lwd=1) +
  geom_jitter(aes(shape = site, fill = site),
              size = 5, stroke = 1.5, width = 0.05, height = 0.05) +
  theme_classic(14) +
  labs(x = " ",
       y = "Simpson's Diversity (1-D)") +
  scale_fill_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  scale_colour_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  theme(panel.border = element_rect(fill = NA)) +
  scale_shape_manual(values = c(21, 24, 22)) +
  theme(legend.position = "none") +
  ylim(0,1) +
  scale_x_discrete(labels = c("station1" = "Station 1",
                              "station2" = "Station 2",
                              "station3" = "Station 3"))

shannon <- ggplot(univariate, aes(x = site, y = shannon)) +
  geom_boxplot(lwd=1) +
  geom_jitter(aes(shape = site, fill = site),
              size = 5, stroke = 1.5, width = 0.05, height = 0.05) +
  theme_classic(14) +
  labs(x = " ",
       y = "Shannon-Wiener Diversity (H')") +
  scale_fill_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  scale_colour_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  theme(panel.border = element_rect(fill = NA)) +
  scale_shape_manual(values = c(21, 24, 22)) +
  theme(legend.position = "none") +
  ylim(0,2) +
  scale_x_discrete(labels = c("station1" = "Station 1",
                              "station2" = "Station 2",
                              "station3" = "Station 3"))

pielou <- ggplot(univariate, aes(x = site, y = pielous)) +
  geom_boxplot(lwd=1) +
  geom_jitter(aes(shape = site, fill = site),
              size = 5, stroke = 1.5, width = 0.05, height = 0.05) +
  theme_classic(14) +
  labs(x = " ",
       y = "Pielou's Evenness (J)") +
  scale_fill_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  scale_colour_manual(values = c("#BA251E","#F2C73B", "#48484B")) +
  theme(panel.border = element_rect(fill = NA)) +
  scale_shape_manual(values = c(21, 24, 22)) +
  theme(legend.position = "none") +
  ylim(0,1.5) +
  scale_x_discrete(labels = c("station1" = "Station 1",
                              "station2" = "Station 2",
                              "station3" = "Station 3"))


# put the figures you want together into one panel
panel <- abundance + richness1 + simpson + pielou + # figure names 
  plot_annotation(tag_levels ='A') # add labels (e.g, A,B,C,D)

# save that figure into the output 
ggsave("output/univariate_panel.jpeg",
       height = 10.6,
       width = 7.99)

