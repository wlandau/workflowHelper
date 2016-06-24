#' @title Function \code{commands}
#' @description Turn a collection of R expressions into 
#' a named character vector of R commands readable by \code{plan_workflow}. 
#' These commands are to generate datasets, analyze
#' datasets, etc. You must specify the names of the fields.
#' For example, write \code{commands(x = data(y), z = 3)} instead of 
#' \code{commands(x, z)} or \code{commands(data(y), 3)}
#' @export
#' @seealso \code{plan_workflow}
#' @return the \code{datasets}, \code{analyses}, \code{summaries}, \code{aggregates},
#' or \code{output} argument to \code{plan_workflow}
#' @param ... Named commands
commands = function(...) {
  args = structure(as.list(match.call()[-1]), class = "uneval")
  if(!length(args)) return()
  keys = names(args)
  out = as.character(args)
  names(out) = keys
  if(is.null(keys) | any(!nchar(keys)) | any(!nchar(out))) 
    stop("All commands and their names/keys must be given. For example, write commands(x = data(y), z = 3) instead of commands(x, z) or commands(data(y), 3).")
  if(anyDuplicated(keys)) stop("Commands must be given unique names. No duplicates allowed.")
  out
}

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
    fields$targets = c(fields$targets, list_targets(stages[[i]], names(stages)[i], stages))
  }
  write(as.yaml(fields), remakefile)
  yaml_yesno_truefalse(remakefile)
  if(!is.null(makefile)) 
    write_makefile(makefile = makefile, remakefiles = remakefile, begin = begin, 
      clean = clean, remake_args = remake_args)
}

#' @title Function \code{reps}
#' @description Replicate commands. For example, if
#' \code{x <- commands(data1 = rnorm(5), data2 = rpois(5,1))}, then
#' \code{reps(x, 2)} is
#' @export
#' @seealso \code{commands}
#' @return the \code{datasets}, \code{analyses}, \code{summaries}, \code{aggregates},
#' or \code{output} argument to \code{plan_workflow}
#' @param x Character vector of commands, possibly returned from the
#' \code{commands} function or \code{strings} function.
#' @param reps Number of replicates.
reps = function(x, reps = 2) {
  reps = floor(reps)
  if(reps < 2 | !length(x)) return(x)
  n = names(x)
  l = length(n)
  x = rep(x, each = reps)
  n = rep(n, each = reps)
  n = paste0(n, "_rep", rep(1:reps, times = l))
  names(x) = n
  x
}

#' @title Function \code{strings}
#' @description Turns expressions into character strings
#' @export
#' @return a named character vector
#' @param ... list of expressions to turn into character strings
strings = function(...) {
  args = structure(as.list(match.call()[-1]), class = "uneval")
  keys = names(args)
  out = as.character(args)
  names(out) = keys
  out
}
