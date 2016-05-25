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
#' @param clean Character vector of extra shell commands for \code{make clean}.
#' @param makefile Character, name of the Makefile. Should be in the current
#' working directory. Otherwise, the \code{YAML} files will not be found
#' and the \code{make} will not work.
plan_workflow = function(sources, datasets = NULL, analyses = NULL, summaries = NULL, output = NULL, clean = NULL, makefile = "Makefile"){
  is_source = grepl("\\.[rR]$", sources)
  packages = sources[!is_source]
  sources = sources[is_source]
  aggregates = summaries

  stage_names = c("datasets", "analyses", "summaries", "aggregates", "output")
  stage_names = stage_names[sapply(stage_names, function(x){!is.null(get(x))})]

  for(item in stage_names){
    if(anyDuplicated(names(get(item)))) stop("argument vectors cannot have duplicate names.")
    assign(item, data.frame(save = names(get(item)), command = get(item), stringsAsFactors = F))
  }

  summaries = parse_summaries(datasets, analyses, summaries)
  analyses = parse_analyses(datasets, analyses)

  initial_stage_names = stage_names[stage_names != "aggregates" & stage_names != "output"]
  for(item in initial_stage_names) plan_stage(get(item), sources, packages)
  if(!is.null(aggregates)) plan_aggregates(summaries, aggregates, sources, packages)
  if(!is.null(output)) plan_output(output, sources, packages)

  stages = lapply(stage_names, function(x) name_yml(get(x)$save))
  names(stages) = stage_names
  write_makefile(stages, file = makefile, clean = c(paste0("rm -rf ", macro("cache")), clean))
}
