setwd("C:/Users/Hendrik/Documents/Programming/R/simpel_ExpAI")

source('scripts/load_packages.R')

source('scripts/load_dataset.R')

source('scripts/randomforest.R')

# source('scripts/explainer_objects.R')

# source('scripts/fairness/functions.R')
# source('scripts/fairness/script.R')

source('scripts/explainability/functions.R')
make_vars(model_fitted2, GCR_train, "Risk", label = 'RandomForest', PDP_variable = 'Job', seed = 123)     #FIXME
source('scripts/explainability/script.R')
