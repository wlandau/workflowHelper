#' @include utils.R
NULL

#' @title Internal function
#' @description Internal function
#' @export
#' @param output Data frame about output to generate.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
#' @param depends all possible RDS cached dependencies for output
plan_output = function(output, sources, packages, depends){
  ddply(output, colnames(output), function(x){
    fields = init_fields(sources, packages, x$save)
    fields = add_rule(fields, x$save, x$command)
    fields$targets[[x$save]]$depends = c(fields$targets[[x$save]]$depends, depends)
    write_yaml(fields, name_yml(x$save))
  })
}
