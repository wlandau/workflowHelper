#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_analysis}
#' @description Internal function to plan analysis
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string of command to run.
#' @param dataset Character string, dataset to analyze
#' @param analysis Character string, analysis method
plan_analysis = function(sources, packages, command, dataset, analysis){
  out = paste(dataset, analysis, sep = "_")
  file = out
  yaml = paste0(out, ".yml")
  for(item in c("file", "dataset")){
    assign(item, paste0(get(item), ".rds"))
    command = gsub(placeholders()[item], paste0("\"", get(item), "\""), command)
  }
  single_step(sources, packages, command, file, yaml)
  out
}
