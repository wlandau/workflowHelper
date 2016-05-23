#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_output}
#' @description Internal function to compute final output
#' @export
#' @return name of output
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character vector of commands to run.
#' @param output Character string, output to compute
#' @param summaries Character string, names of summaries of analyses
plan_output = function(sources, packages, command, output, summaries){
  depends = summaries
  place = placeholders()["summaries"]
  names(depends) = paste0(summaries, place)
  replacements = paste(names(depends), collapse = ", ")
  names(replacements) = place
  single_step(sources, packages, command, output, depends, replacements)
  output
}
