#' @include placeholders.R single_step.R
NULL

#' @title Function \code{plan_output}
#' @description Internal function to compute final output
#' @export
#' @return name of output
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character vector of commands to run.
#' @param output Character string, output to compute
plan_output = function(sources, packages, command, output){
  fields = list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = output)
    )
  )
  fields$targets[[output]] = list(command = command)
  write_yaml(fields, paste0(output, ".yml"))
  output
}
