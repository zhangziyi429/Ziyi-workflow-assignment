
install.packages("here")
install.packages("vroom")

library(tidyverse)
library(here)
library(vroom)
library(readxl)

rm(list = ls())

# create a for loop for reading dataset


# files <- list.files(here("Ziyi-workflow-assignment"), pattern = "Data entry.xlsx", recursive = T)
# evaluation <- vroom(here("Ziyi-workflow-assignment",files))


Data_entry_1 <- read_excel("Data entry_Becca.xlsx")
Data_entry_2 <- read_excel("Data entry_Devon.xlsx")
Data_entry_3 <- read_excel("Data entry_Karlee.xlsx")


