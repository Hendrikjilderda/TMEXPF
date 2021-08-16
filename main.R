setwd("C:/Users/Hendrik/Documents/Programming/R/simpel_ExpAI")

source('scripts/load_packages.R')

source('scripts/load_dataset.R')

source('scripts/randomforest.R')


source('EXPF/explainability/functions.R')
make_vars(model_fitted2, GCR_train, "Risk", label = 'RandomForest', PDP_variable = 'Job', seed = 2121)   
source('EXPF/explainability/script.R') 


source('EXPF/fairness/functions.R')
make_fairness_vars(explainer, GCR_train$Sex, "male", 0.5)
source('EXPF/fairness/script.R')



plot(plot_SHAP)

plot(plot_BD)

plot(plot_CP)

plot(plot_VIP)

plot(plot_PDP)
