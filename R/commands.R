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
  out
}
