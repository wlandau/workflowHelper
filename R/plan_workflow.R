 #' @include parse_analyses.R parse_summaries.R plan_aggregates.R plan_output.R plan_stage.R
NULL

#' @title Function \code{plan_workflow}
#' @description Main function of the package. Produces a Makefile to run an workflow.
#' @export
#' @param sources Named character vector, code files and packages to load.
#' Code files should end in \code{.r} or \code{.R}. Otherwise, they will
#' be assumed to be packages.
#' @param datasets Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param analyses Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param summaries Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param output Named character vector of commands to make targets.
#' Names stand for files (possible non-RDS files) WITH their extensions.
plan_workflow = function(sources, datasets = NULL, analyses = NULL, summaries = NULL, output = NULL){
  is_source = grepl("\\.[rR]$", sources)
  packages = sources[!is_source]
  sources = sources[is_source]
  aggregates = summaries

  args = c("datasets", "analyses", "summaries", "aggregates", "output")
  args = args[sapply(args, function(x){!is.null(get(x))})]

  for(item in args){
    if(anyDuplicated(names(get(item)))) stop("argument vectors cannot have duplicate names.")
    assign(item, data.frame(save = names(get(item)), command = get(item), stringsAsFactors = F))
  }

  summaries = parse_summaries(datasets, analyses, summaries)
  analyses = parse_analyses(datasets, analyses)

  args0 = args[args != "aggregates" & args != "output"]
  for(item in args0) plan_stage(get(item), sources, packages)
  if(!is.null(aggregates)) plan_aggregates(summaries, aggregates, sources, packages)
  if(!is.null(output)) plan_output(output, sources, packages)

  stages = lapply(args, function(x) get(x)$save)  
  write_makefile(stages)
}
