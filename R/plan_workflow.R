#' @title Function \code{plan_workflow}
#' @description Main function of the package. Produces a Makefile to run a workflow.
#' @export
#' @param sources Character vector of code files to load or folders containing code.
#' @param packages Character vector of packages to load.
#' @param datasets Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param analyses Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param summaries Named character vector of commands to make targets.
#' Names stand for RDS target files without their extensions.
#' @param output Named character vector of commands to make targets.
#' Names stand for files (possible non-RDS files) WITH their extensions.
#' @param makefile Character, name of the Makefile. Should be in the current
#' working directory. Set to \code{NULL} to suppress the writing of the Makefile.
#' @param remakefile Character, name of the \code{remake} file to generate. Should be in the current working directory.
#' @param begin Character vector of lines to prepend to the Makefile.
#' @param clean Character vector of extra shell commands for \code{make clean}.
#' @param remake_args Fully-named list of additional arguments to \code{remake::make}.
#' You cannot set \code{target_names} or \code{remake_file} this way.
plan_workflow = function(sources, packages = NULL, datasets = NULL, analyses = NULL, summaries = NULL, output = NULL, makefile = "Makefile", remakefile = "remake.yml", begin = NULL, clean = NULL, remake_args = list()){

  aggregates = summaries
  stage_names = c("datasets", "analyses", "summaries", "aggregates", "output")
  stage_names = stage_names[sapply(stage_names, function(x){!is.null(get(x))})]

  for(item in stage_names){
    if(anyDuplicated(names(get(item)))) stop("argument vectors cannot have duplicate names.")
    assign(item, data.frame(save = names(get(item)), command = get(item), stringsAsFactors = F))
  }

  summaries = parse_summaries(datasets, analyses, summaries)
  analyses = parse_analyses(datasets, analyses)
  aggregates = parse_aggregates(aggregates, summaries)

  fields = init_fields(sources, packages, c(output$save, stage_names))
  for(item in stage_names){
    df = get(item)
    fields = add_rule(fields, item, df$save, "depends")
    for(i in 1:nrow(df))
      fields = add_rule(fields, df[i, "save"], df[i, "command"])
  }
  write(as.yaml(fields), remakefile)
  if(!is.null(makefile)) 
    write_makefile(makefile = makefile, remakefiles = remakefile, begin = begin, 
      clean = clean, remake_args = remake_args)
}
