#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_summary}
#' @description Internal function to summarize an analysis
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string, command to run.
#' @param dataset Character string, dataset to analyze
#' @param analysis Character string, analysis method
#' @param summary Character string, summary method
plan_summary = function(sources, packages, command, dataset, analysis, summary){
  out = paste(dataset, analysis, summary, sep = "_")
  file = out
  yaml = paste0(out, ".yml")
  analysis = paste(dataset, analysis, sep = "_")
  for(item in c("file", "dataset", "analysis")){
    assign(item, paste0(get(item), ".rds"))
    command = gsub(placeholders()[item], paste0("\"", get(item), "\""), command)
  }
  single_step(sources, packages, command, file, yaml)
  out
}
