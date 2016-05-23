#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_summary}
#' @description Internal function to summarize an analysis
#' @export
#' @return name of summary
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string, command to run.
#' @param dataset Character string, dataset to analyze
#' @param analysis Character string, analysis method
#' @param summary Character string, summary method
plan_summary = function(sources, packages, command, dataset, analysis, summary){
  save = paste(dataset, analysis, summary, sep = "_")
  analysis = paste(dataset, analysis, sep = "_")
  place = placeholders()[c("dataset", "analysis")]
  depends = c(dataset, analysis)
  names(depends) = replacements = paste0(depends, place)
  names(replacements) = place
  single_step(sources, packages, command, save, depends, replacements)
  save
}
