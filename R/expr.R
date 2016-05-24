#' @title Function \code{expr}
#' @description Turns expressions into character strings
#' @export
#' @return a character vector
#' @param ... list of expressions
expr = function(...) {
  args = structure(as.list(match.call()[-1]), class = "uneval")
  if(!length(args)) return()
  as.character(args)
}
