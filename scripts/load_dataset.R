GCR <- read.csv('./data/german_credit_data.csv',
                header = TRUE)

GCR <- GCR %>% select(-X)

GCR$Amount.month <- (GCR$Credit.amount / GCR$Duration)

GCR$Risk <- as.factor(ifelse(GCR$Risk == 'good', '0', '1'))

GCR$Sex <- as.factor(GCR$Sex)
GCR$Housing <- as.factor(GCR$Housing)
GCR$Saving.accounts <- as.factor(GCR$Saving.accounts)
GCR$Checking.account <- as.factor(GCR$Checking.account)
GCR$Purpose <- as.factor(GCR$Purpose)

GCR <- na.omit(GCR)     #niet gebruiken voor optimale accuracy

set.seed(123)
GCR_split <- initial_split(GCR, strata = Risk)
GCR_train <- training(GCR_split)
GCR_test <- testing(GCR_split)