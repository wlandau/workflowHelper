#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_aggregate}
#' @description Internal function to aggregate summaries
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string, command to run
#' @param aggregate Character string, aggretation method
#' @param summaries Character vector, methods of summarizing analysis
plan_aggregate = function(sources, packages, command, aggregate, summaries){
  depends = summaries
  place = placeholders()["summaries"]
  names(depends) = paste0(place, summaries)
  replacements = paste(names(depends), collapse = ", ")
  names(replacements) = place
  single_step(sources, packages, command, aggregate, depends, replacements)
  aggregate
}
