GCR <- read.csv('./data/german_credit_data.csv',
                header = TRUE)



GCR <- na.omit(GCR)     #niet gebruiken voor optimale accuracy

set.seed(123)
GCR_split <- initial_split(GCR, strata = Risk)
GCR_train <- training(GCR_split)
GCR_test <- testing(GCR_split)