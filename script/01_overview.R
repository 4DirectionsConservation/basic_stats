# Info about session ------------------------------------------------------

# I have captured what my set up looks like as of making these scripts - 
# RStudio, R, and packages all update so if something is broken this will 
# help you figure things out

sessionInfo()

# R version 4.3.0 (2023-04-21 ucrt)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 11 x64 (build 22621)
# 
# Matrix products: default
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
# [1] lubridate_1.9.2 forcats_1.0.0   stringr_1.5.0   dplyr_1.1.2     purrr_1.0.1    
# [6] readr_2.1.4     tidyr_1.3.0     tibble_3.2.1    ggplot2_3.4.2   tidyverse_2.0.0
# 
# loaded via a namespace (and not attached):
# [1] vctrs_0.6.2      cli_3.6.1        rlang_1.1.1      stringi_1.7.12   renv_0.17.3     
# [6] generics_0.1.3   glue_1.6.2       colorspace_2.1-0 hms_1.1.3        scales_1.2.1    
# [11] fansi_1.0.4      grid_4.3.0       munsell_0.5.0    tzdb_0.4.0       lifecycle_1.0.3 
# [16] compiler_4.3.0   timechange_0.2.0 pkgconfig_2.0.3  rstudioapi_0.14  R6_2.5.1        
# [21] tidyselect_1.2.0 utf8_1.2.3       pillar_1.9.0     magrittr_2.0.3   tools_4.3.0     
# [26] withr_2.5.0      gtable_0.3.3


# Resources ---------------------------------------------------------------

# there are a lot of free resources for learning R if you are new, some examples:

# https://datacarpentry.org/R-ecology-lesson/
# https://r4ds.had.co.nz/

# always google a question, usually there is an answer
# 'help' tab has lots of information, every library has a 'vignette' 

# short course for help with using GitHub
# https://github.com/emmajhudgins/WEN_github 

# Libraries ---------------------------------------------------------------
# you will have to install these the first time you run them
# go to tools > install packages > start typing the name

library(tidyverse) # for organizing data etc. - see https://r4ds.had.co.nz/
# pipes ( %>% (ctrl-shift-m)) are used to organize operations

# # includes
# > library(tidyverse)
# ── Attaching core tidyverse packages ─────────────────────────────────────── tidyverse 2.0.0 ──
# ✔ dplyr     1.1.2     ✔ readr     2.1.4
# ✔ forcats   1.0.0     ✔ stringr   1.5.0
# ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
# ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
# ✔ purrr     1.0.1   

library(janitor) #useful functions for cleaning up data
# https://www.rdocumentation.org/packages/janitor/versions/2.2.0


# Data Import -------------------------------------------------------------

# Using invertebrate data from a previous project (PUI)

# this is invertebrate community data
# if you have community data THIS IS THE FORMAT it needs to be in

data <- read.csv('data/invert_data.csv')

data # look at all the data
dim(data) # dimensions (rows, columns)
colnames(data) #column names
head(data) # first 6 rows
str(data) # variable type (many problems can come from variables being the wrong type)

# change 'character' to 'factor

data$site <- as.factor(data$site)
str(data)






