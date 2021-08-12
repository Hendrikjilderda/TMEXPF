
train <- GCR_train

.GlobalEnv$explainer_randomforest <- DALEX::explain(
  model = custom_model_expl(model_fitted),
  data = custom_data_expl(model_fitted, train, "Risk"),
  y = custom_y_expl(model_fitted, train, "Risk"),
  label = "randomforest")

.GlobalEnv$fobject <- fairness_check(explainer_randomforest,
               protected = GCR_train$Sex,
               privileged = "male",
               cutoff = 0.5)