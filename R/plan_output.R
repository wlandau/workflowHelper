#' @include macros.R single_step.R
NULL

#' @title Function \code{plan_output}
#' @description Internal function to compute final output
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character vector of commands to run.
#' @param output Character string, output to compute
plan_output = function(sources, packages, command, output){
  out = output
  file = out
  yaml = paste0(out, ".yml")
  single_step(sources, packages, command, file, yaml)
  out
}
