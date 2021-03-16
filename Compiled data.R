
install.packages("here")
install.packages("vroom")
install.packages("tidyverse")
install.packages("readxl")

library(tidyverse)
library(here)
library(vroom)
library(readxl)

rm(list = ls())


# create a function to read file with/without column names

rexcel <- function (x, y){
  stopifnot("ERROR: the second input should be logical" = is.logical(y))
  library(readxl)
  read_excel(x, col_name = y)
}

Data_entry_1 <- rexcel("Data entry_Becca.xlsx", F)
Data_entry_2 <- rexcel("Data entry_Devon.xlsx", F)
Data_entry_3 <- rexcel("Data entry_Karlee.xlsx", F)
F_scores <- rexcel("Index with F score.xlsx", T)

# clean IV data 
# for data entry one, take off last three columns

Data_entry_1 <- Data_entry_1 %>% select(1:9)

# integrate all three IV files and add the coder column to identify different coders



# add a rank column to IV file



# clean DV data, keep F scores in 2018 and company rank



# add a logical column to match ranks in IV and DV files, so that the F scores can be matched
# with coder evaluations



# integrate IV and DV files in one large file with a correct order



