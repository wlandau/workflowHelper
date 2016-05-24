#' @title Internal function
#' @description Internal function
#' @export
#' @param output Data frame about output to generate.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_output = function(output, sources, packages){
  ddply(output, colnames(output), function(x){
    fields = list(
      sources = sources,
      packages = packages,
      targets = list(
        all = list(depends = x$save)
      )
    )
    fields$targets[[x$save]] = list(command = x$command)
    write_yaml(fields, paste0(x$save, ".yml"))
  })
}
