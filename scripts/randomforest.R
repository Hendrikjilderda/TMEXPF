custom_predict <- function(object, newdata, positive_value) { pred <- predict(object, newdata, type = 'prob')
response <- as.vector(t(pred[paste('.pred_', positive_value, sep = '')]))
return(response)}

custom_data_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- as.data.frame(prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% select(-target_variable))
  return(data_return)
}
custom_y_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% mutate(target_variable = ifelse(target_variable == 'good', 1, 0))  %>% pull(target_variable)
  return(data_return)
}
custom_model_expl <- function(recipe_workflow) {return(recipe_workflow$fit$fit)}

custom_new_obs <- function(recipe_workflow, dataset, target_variable, rownumber) {
  new_obs <- as.data.frame(prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% bake(dataset) %>% select(-target_variable))[rownumber,]
  return(new_obs)
}


set.seed(123)
GCR_split <- initial_split(GCR, strata = Risk)
GCR_train <- training(GCR_split)
GCR_test <- testing(GCR_split)

GCR_recipe <- recipe(Risk ~ ., data = GCR_train) %>%
  step_mutate(Amount.month = Credit.amount / Duration) %>%
  step_string2factor(all_nominal(), -all_outcomes()) %>%
  step_impute_knn(Saving.accounts,  Checking.account) %>%
  step_other(Purpose, threshold = 0.10, other = 'other_value')# is dit wel nodig? van 8 naar 4

rf_model <-
  rand_forest(mtry = 8, trees = 500, min_n = 5) %>%
  set_engine("randomForest") %>%
  set_mode("classification")

rf_workflow <-
  workflow() %>%
  add_recipe(GCR_recipe) %>%
  add_model(rf_model)

model_fitted2 <- rf_workflow %>%
  fit(data = GCR_train)

test <- model_fitted2 %>%
  predict(new_data = GCR_train)




