#' @title Function \code{single_step}
#' @description Internal function to plan a stage of the workflow. 
#' Utility function of \code{plan_workflow}.
#' @seealso \code{plan_workflow}
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command dependsd character vector of commands to run.
#' @param file target file to make
#' @param yaml YAML/remake file to use
single_step = function(sources, packages, command, file, yaml){
  fields = list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = file)
    )
  )
  fields$targets[[file]] = list(command = command)
  write_yaml(fields, yaml)
}
