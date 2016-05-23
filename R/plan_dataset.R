#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_dataset}
#' @description Internal function to plan dataset generation
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string, command to run.
#' @param dataset Character string, dataset to generate
plan_dataset = function(sources, packages, command, dataset){
  out = dataset
  save = paste0(out, ".rds")
  yaml = paste0(out, ".yml")
  command = gsub(placeholders()["save"], paste0("\"", save, "\""), command)
  single_step(sources, packages, command, save, yaml)
  out
}
