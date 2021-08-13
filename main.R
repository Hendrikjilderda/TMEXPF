setwd("C:/Users/Hendrik/Documents/Programming/R/simpel_ExpAI")

source('scripts/load_packages.R')

source('scripts/load_dataset.R')

source('scripts/randomforest.R')


source('scripts/explainability/functions.R')
make_vars(model_fitted2, GCR_train, "Risk", label = 'RandomForest', PDP_variable = 'Job', seed = 123)   
source('scripts/explainability/script.R') #plots printen nog niet direct. moeten lost geprint worden


source('scripts/fairness/functions.R')
make_fairness_vars(explainer, GCR_train$Sex, "male", 0.5)
source('scripts/fairness/script.R')
