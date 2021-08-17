make_fairness_vars <- function(explainer, protected, privileged, cutoff){
  .GlobalEnv$explainer <- explainer
  .GlobalEnv$protected <- protected
  .GlobalEnv$privileged <- privileged
  .GlobalEnv$cutoff <- cutoff
}


gen_fobject <- function(explainer, protected, privileged, cutoff = 0.5){
  local_fobject <- fairness_check(explainer,
                                  protected = protected,
                                  privileged = privileged,
                                  cutoff = cutoff)
}

