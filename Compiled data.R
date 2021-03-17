
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

# rename colunms (tried for loop but failed)

Data_entry_1 <- Data_entry_1 %>% rename(Company_Name = '...1', Q1 = '...2', Q2 = '...3', Q3 = '...4', Q4 = '...5', 
                        Q5 = '...6', Q6 = '...7', Q7 = '...8', Q8 = '...9')
Data_entry_2 <- Data_entry_2 %>% rename(Company_Name = '...1', Q1 = '...2', Q2 = '...3', Q3 = '...4', Q4 = '...5', 
                                        Q5 = '...6', Q6 = '...7', Q7 = '...8', Q8 = '...9')
Data_entry_3 <- Data_entry_3 %>% rename(Company_Name = '...1', Q1 = '...2', Q2 = '...3', Q3 = '...4', Q4 = '...5', 
                                        Q5 = '...6', Q6 = '...7', Q7 = '...8', Q8 = '...9')

# integrate all three IV files and add the coder column to identify different coders

Coder_1 <- 1
Coder_2 <- 2
Coder_3 <- 3

Data_entry_1 <- Data_entry_1 %>% add_column(Coder = Coder_1, .before = "Q1")
Data_entry_2 <- Data_entry_2 %>% add_column(Coder = Coder_2, .before = "Q1")
Data_entry_3 <- Data_entry_3 %>% add_column(Coder = Coder_3, .before = "Q1")


Evaluations <- bind_rows(Data_entry_1, Data_entry_2, Data_entry_3)

# add a rank column to IV file
# take off rows end with a or b, just keep 2017's letters

Evaluations_cleaned <- Evaluations %>% separate(Company_Name, sep = "_", into = c("Rank","Year")) %>% 
  mutate(Year = ifelse(Year == "c", 2017, NA)) %>%
  filter(!is.na(Year))

# reverse 1,3,4,6,8 items
# then create a mean score at the end of columns

reverse <- function(a, scale_range){
  stopifnot("ERROR: the scale range should be numeric" = is.numeric(scale_range))

    limit <- scale_range + 1
    a <- limit - a

}

Evaluations_cleaned <- Evaluations_cleaned %>% mutate(Q1 = reverse(Q1, 6), Q3 = reverse(Q3, 6), Q4 = reverse(Q4, 6), 
                               Q6 = reverse(Q6, 6), Q8 = reverse(Q8, 6),)

INB <- Evaluations_cleaned %>% select(Q1:Q8) %>% rowMeans()
Evaluations_cleaned <- Evaluations_cleaned %>% add_column(INB = INB, .after = "Q8")

# final IV file: implicit belief data

INB_Data <- Evaluations_cleaned %>% select(Rank, Coder, INB)
INB_Data <- INB_Data %>% pivot_wider(names_from = "Coder", values_from = "INB")
Mean_INB <- INB_Data %>% select(-Rank) %>% rowMeans(na.rm = T)
INB_Data <- INB_Data %>% add_column(Mean_INB = Mean_INB, .after = "Rank") %>% select(Rank, Mean_INB)


INB_Data <- INB_Data %>% transform(Rank = as.numeric(Rank), 
          Mean_INB = as.numeric(Mean_INB))


INB_Data <- INB_Data [order( INB_Data[,1] ),]


# clean DV data, keep F scores in 2018 and company rank, and order by ranks

F_scores <- F_scores %>% select(`2017 Rank`, `2018 F`) 
F_scores <- F_scores [order( F_scores[,1] ),]

# integrate IV and DV files in one large file with a correct order

F_scores <- F_scores %>% rename(Rank = '2017 Rank')
Compiled_Data <- left_join(INB_Data,F_scores)
Compiled_Data <- Compiled_Data %>% drop_na()

# draw plots
# create boxplots for both two variables to see whether there is any outlier

Compiled_Data %>% ggplot(aes(x = Rank, colour = "smooth", y = Mean_INB)) + 
  geom_boxplot() + 
  ylim(0, 6)

Compiled_Data %>% ggplot(aes(x = Rank, colour = "smooth", y = `2018 F`)) + 
  geom_hline(yintercept = 10) + 
  geom_boxplot()

# there is one in F scores

Compiled_Data <- Compiled_Data %>% mutate(`2018 F` = ifelse(`2018 F` > 100, NA, `2018 F`)) %>% drop_na()

# create scatter plot with two variables

Compiled_Data %>% ggplot(aes(x = Mean_INB, y = `2018 F`)) + geom_point()



