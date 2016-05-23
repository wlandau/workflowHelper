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
  out = aggregate
  file = paste0(out, ".rds")
  yaml = paste0(out, ".yml")
  summaries = paste0("\"", summaries, ".rds\"")
  summaries = paste(summaries, collapse = ", ")
  command = gsub(placeholders()["file"], paste0("\"", file, "\""), command)
  command = gsub(placeholders()["summaries"], summaries, command)
  single_step(sources, packages, command, file, yaml)
  out
}
