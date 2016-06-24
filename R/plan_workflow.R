#' @title Function \code{plan_workflow}
#' @description Main function of the package. Produces a Makefile to run a workflow.
#' @export
#' @param sources Character vector of code files to load or folders containing code.
#' @param packages Character vector of packages to load.
#' @param datasets Named character vector of commands to make datasets.
#' @param analyses Named character vector of commands to make analyses.
#' @param summaries Named character vector of commands to make summaries.
#' @param output Named character vector of commands to make output targets.
#' @param plots Named character vector of commands to make plots.
#' @param reports Named character vector of instructions to make reports.
#' @param makefile Character, name of the Makefile. Should be in the current
#' working directory. Set to \code{NULL} to suppress the writing of the Makefile.
#' @param remakefile Character, name of the \code{remake} file to generate. Should be in the current working directory.
#' @param begin Character vector of lines to prepend to the Makefile.
#' @param clean Character vector of extra shell commands for \code{make clean}.
#' @param remake_args Fully-named list of additional arguments to \code{remake::make}.
#' You cannot set \code{target_names} or \code{remake_file} this way.
plan_workflow = function(sources, packages = NULL, datasets = NULL, analyses = NULL, summaries = NULL, output = NULL, plots = NULL, reports = NULL, makefile = "Makefile", remakefile = "remake.yml", begin = NULL, clean = NULL, remake_args = list()){
  stages = parse_stages(datasets = datasets, analyses = analyses, summaries = summaries, 
     aggregates = summaries, output = output, plots = plots, reports = reports)
  fields = init_fields(sources, packages, names(stages))
  for(i in 1:length(stages)){
    fields$targets[[names(stages)[i]]] = list(depends = stages[[i]]$save)
    fields$targets = c(fields$targets, list_targets(stages[[i]], stages, names(stages)[i] == "reports"))
  }
  write(as.yaml(fields), remakefile)
  yaml_yesno_truefalse(remakefile)
  if(!is.null(makefile)) 
    write_makefile(makefile = makefile, remakefiles = remakefile, begin = begin, 
      clean = clean, remake_args = remake_args)
}
