library(tidyverse)
library(tidymodels)

tidy_kfolds <- vfold_cv(GCR_train)


xg_rec <- recipe(Risk~., data = GCR_train) %>%
  step_impute_knn(Saving.accounts,  Checking.account) %>%  
  step_dummy(all_nominal(), -all_outcomes()) %>% 
  step_impute_median(all_predictors()) %>% 
  step_normalize(all_predictors())

tidy_boosted_model <- boost_tree(trees = tune(),
                                 min_n = tune(),
                                 learn_rate = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("xgboost")

tidy_knn_model <- nearest_neighbor(neighbors = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("kknn")


boosted_grid <- grid_regular(parameters(tidy_boosted_model), levels = 5)
knn_grid <- grid_regular(parameters(tidy_knn_model), levels = 10)





# Dials pacakge 
boosted_grid <- grid_regular(parameters(tidy_boosted_model), levels = 5)
knn_grid <- grid_regular(parameters(tidy_knn_model), levels = 10)

# Tune pacakge 
boosted_tune <- tune_grid(tidy_boosted_model,
                          xg_rec,
                          resamples = tidy_kfolds,
                          grid = boosted_grid)

knn_tune <- tune_grid(tidy_knn_model,
                      xg_rec,
                      resamples = tidy_kfolds,
                      grid = knn_grid)

# getting best params
boosted_param <- boosted_tune %>% select_best("roc_auc")
knn_param <- knn_tune %>% select_best("roc_auc")

# finalizing
tidy_boosted_model <- finalize_model(tidy_boosted_model, boosted_param)
tidy_knn_model <- finalize_model(tidy_knn_model, knn_param)



boosted_wf <- workflow() %>% 
  add_model(tidy_boosted_model) %>% 
  add_recipe(xg_rec)

knn_wf <- workflow() %>% 
  add_model(tidy_knn_model) %>% 
  add_recipe(xg_rec)


boosted_res <- last_fit(boosted_wf, GCR_split)
knn_res <- last_fit(knn_wf, GCR_split)


bind_rows(
  boosted_res %>% mutate(model = "xgb"),
  knn_res %>% mutate(model = "knn")
) %>% 
  unnest(.metrics)
boosted_res %>% unnest(.predictions) %>% 
  conf_mat(truth = Risk, estimate = .pred_class)


# Fit the entire data set using the final wf 
final_boosted_model <- fit(boosted_wf, GCR)
saveRDS(final_boosted_model, "GCR_xgmodel.rds")
