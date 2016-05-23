#' @title Function \code{single_step}
#' @description Internal function to plan a stage of the workflow. 
#' Utility function of \code{plan_workflow}.
#' @seealso \code{plan_workflow}
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command dependsd character vector of commands to run.
#' @param save target file to save
#' @param yaml YAML/remake file to use
single_step = function(sources, packages, command, save, yaml){
  fields = list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = save)
    )
  )
  fields$targets[[save]] = list(command = command)
  write_yaml(fields, yaml)
}
