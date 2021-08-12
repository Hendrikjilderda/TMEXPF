
train <- GCR_train

e_data <- custom_data_expl(model_fitted, train, "Risk")

.GlobalEnv$explainer_randomforest <- DALEX::explain(
  model = custom_model_expl(model_fitted),
  data = custom_data_expl(model_fitted, train, "Risk"),
  y = custom_y_expl(model_fitted, train, "Risk"),
  label = "randomforest")

.GlobalEnv$fobject <- fairness_check(explainer_randomforest,
               protected = GCR_train$Sex,
               privileged = "male",
               cutoff = 0.5)


# todo:
# maken van functies voor fairness 
# bv. heatmap, boxplots etc -> check fiarness bladwijzer

# verder nog testn met het explainability script!

case <- e_data[sample(1:nrow(e_data),1),]

SHAP_val <- DALEX::predict_parts(
  explainer = explainer_randomforest,
  new_observation = case,
  type = "shap"
)
plot(SHAP_val)


CP_val <- ingredients::ceteris_paribus(x = explainer_randomforest,
                                       new_observation = case)

plot(CP_val)

VIP_Val <- DALEX::model_parts(
  explainer = explainer_randomforest,
  loss_function = DALEX::loss_root_mean_square
)
plot(VIP_Val)
