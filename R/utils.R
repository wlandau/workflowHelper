add_rule = function(fields, name, value, key = "command"){
  fields$targets[[name]] = list()
  fields$targets[[name]][[key]] = value
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

macro = function(arg){
  c(
    dataset = "..DATASET..",
    analysis = "..ANALYSIS.."
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
