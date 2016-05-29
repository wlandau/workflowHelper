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
