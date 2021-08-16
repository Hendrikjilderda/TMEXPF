
if(!exists('model_fitted') || !exists('train_data') || !exists('target_variable')){
  stop('[debug]not able to make explainer because of missing variables')
  
} else {
  if(!exists('gen_explainer') || !exists('SHAP') || !exists('BD') ||
     !exists('CP') ||  !exists('VIP') || 
     !exists('PDP')) {
    
    source("scripts/explainability/DALEX_functions.R")
  }
  
  amount_functions <- 5
  
  .GlobalEnv$explainer <- gen_explainer(model_fitted, train_data, target_variable, label)
  
  list <- vector(mode = "list", length = 0)
  plot_list <- vector(mode = "list", length = 0)
  plot_counter <- 0 
  message('expl created')
  
  try(
    if(exists('case')){
      .GlobalEnv$plot_SHAP <- SHAP(explainer, case)
      list <- c(list, 1)
      message('SHAP made')
    } else {
      warning('not able to make Shapley plot, case not specified')
    }
  )
  
  try({
    .GlobalEnv$plot_BD <- BD(explainer, case)
    list <- c(list, 2)
    message('BP made')
  })  
  
  
  try(
    if (!is.null('CP_var')){
      plot_CP <- CP(explainer, case)
      list <- c(list, 3)
      message('CP made')
    } else{
      warning('not able to make certis_paribus profile, variables or/and case not specified')
      
    }
  )
  
  
  
  
  try({
    .GlobalEnv$plot_VIP <- VIP(explainer)
    list <- c(list, 4)
    message('VIP made')######
  })
  
  try(
    if(!is.null('PDP_var')){
      variable <- 'Job'
      .GlobalEnv$plot_PDP <- PDP(explainer, PDP_variable)  #FIXME
      list <- c(list, 5)
      message('PDP made')
    }
  )
  
  
  for(plot in list) {
    if(plot == 1){    #FIxME
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_SHAP
        plot(plot_SHAP)
      } else{
        plot_list <- c(plot_list, plot_SHAP)
        plot(plot_SHAP)
      }
    }else if(plot == 2){ 
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_BD
      } else{
        plot_list <- c(plot_list, plot_BD)
        plot(plot_BD)
      }
    }else if (plot == 3){
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_CP
        plot(plot_CP)
      } else{
        plot_list <- c(plot_list, plot_CP)
        plot(plot_CP)
      }
    }else if (plot == 4){
      if(!exists('plot_list')) {
        plot_list <- vector(mode = "list", length = 1)
        plot_list[1] <- plot_VIP
      } else{
        plot_list <- c(plot_list, plot_VIP)
        plot(plot_VIP)
      }
    }else if (plot == 5){
      plot_list <- c(plot_list, plot_PDP)
      plot(plot_PDP)
    }
  }
  
  
}
