add_target = function(fields, name, target, all_depends){
  out = as.list(target)
  if(!is.null(out$knitr)) if(out$knitr){ 
    out$depends = unique(c(out$depends, all_depends[all_depends != "output"]))
    if(nchar(out$command)) out$knitr = list(options = as.list(eval(parse(text = out$command))))
    out$command = NULL
  }
  keep = !sapply(out, function(x) is.null(x) | identical(x, F)) &
    names(out) %in% c("command", "depends", "knitr", "plot")
  fields$targets[[name]] = out[keep]
  fields
}

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
#' @param ... list of 
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

expand_grid_df = function(...) 
  Reduce(function(...) merge(..., by = NULL), list(...))

init_fields = function(sources, packages, dep){
  list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = dep)
    )
  )
}

#' @title Function \code{macro}
#' @description Get a placeholder macro. These macros help
#' apply each analysis to each dataset and each summary to each
#' analysis of each dataset. Macros are not case-sensitive.
#' @export
#' @return The chosen macro.
#' @param arg Character, name of the macro you want.
macro = function(arg){
  c(
    dataset = "\\.\\.dataset\\.\\.",   
    analysis = "\\.\\.analysis\\.\\.",
    plot = "\\.\\.plot\\.\\.",
    knitr = "\\.\\.(knitr|report)\\.\\."
  )[arg]
}

name_list = function(items, quoted = F){
  if(quoted) items = paste0("\"", items, "\"")
  items = sort(items)
  items = paste(items, collapse = ", ")
  paste0("list(", items, ")")
}

new_dir = function(path){
  split = unlist(strsplit(path, "/"))
  if(length(split)) for(i in 1:length(split)){
    x = paste(split[1:i], collapse = "/")
    if(!file.exists(x)) dir.create(x)
  }
  if(substr(path, nchar(path), nchar(path)) != "/") path = paste0(path, "/")
  path
}

#' @title Function \code{remove_assignment_from_command}
#' @description Special function to handle command syntax.
#' Turns "..plot.. <- mse_plot(mse)" into "mse_plot(mse)", etc.
#' @export
#' @seealso \code{plan_workflow}
#' @return parsed command
#' @param cmd Command to clean
#' @param x Name of value assigned to by the command.
remove_assignment_from_command = function(cmd, x){
  cmd = gsub(x, "", cmd, ignore.case = T)
  cmd = str_trim(cmd)
  cmd = gsub("->|<-", "", cmd, ignore.case = T)
  str_trim(cmd)
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
