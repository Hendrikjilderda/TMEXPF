custom_model_expl <- function(recipe_workflow) {return(recipe_workflow$fit$fit)}

custom_data_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- as.data.frame(prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% 
                                 bake(dataset) %>% 
                                 select(-target_variable))
  
  return(data_return)
}

custom_y_expl <- function(recipe_workflow, dataset, target_variable) { 
  data_return <- prep(recipe_workflow$pre$actions$recipe$recipe, dataset) %>% 
    bake(dataset) %>% 
    mutate(target_variable = ifelse(target_variable == 'good', 1, 0))  %>% 
    pull(target_variable)
  
  return(data_return)
}


make_vars <- function(model_fitted, train_data, target_variable, label = NULL, PDP_variable, seed = 21){
  set.seed(seed)
  
  #for explainer
  .GlobalEnv$model_fitted <- model_fitted
  .GlobalEnv$train_data <- train_data
  .GlobalEnv$target_variable <- target_variable
  .GlobalEnv$label <- label
  .GlobalEnv$PDP_variable <- PDP_variable
  
  
  e_data <- custom_data_expl(model_fitted2, GCR_train, "Risk")
  
  #single case
  .GlobalEnv$case <- e_data[sample(1:nrow(e_data),1),]
}


gen_explainer <- function(model_fitted, train_data, target_variable, label){
  local_explainer <- DALEX::explain(
  model = custom_model_expl(model_fitted),
  data = custom_data_expl(model_fitted, train_data,  target_variable),
  y = custom_y_expl(model_fitted, train_data,  target_variable),
  label = label)
  
  return(local_explainer)
}
  


SHAP <- function(explainer, case) {
  #calculate shap values
  SHAP_val <- DALEX::predict_parts(
    explainer = explainer,
    new_observation = case,
    type = "shap"
  )
  return(SHAP_val)
}


CP <- function(explainer, case) {
  #calculate Ceteris- paribus plots
  CP_val <- ingredients::ceteris_paribus(x = explainer,
                                         new_observation = case)
  return(CP_val)
}


BD <- function(explainer, case){
  BD_val <- iBreakDown::local_attributions(explainer, 
                                           case, 
                                           keep_distributions = TRUE)
  
  return(BD_val)
}


VIP <- function(explainer) {
  VIP_Val <- DALEX::model_parts(
    explainer = explainer,
    loss_function = DALEX::loss_root_mean_square
  )
  return(VIP_Val)
}


PDP <- function(explainer, variable) {
  PDP_val <- DALEX::model_profile(explainer = explainer,
                                  variables = variable)
  return(PDP_val)
}

