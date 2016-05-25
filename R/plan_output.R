#' @title Internal function
#' @description Internal function
#' @export
#' @param output Data frame about output to generate.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
#' @param depends Character vector of possible dependencies
plan_output = function(output, sources, packages, depends){
  ddply(output, colnames(output), function(x){
    fields = init_fields(sources, packages, x$save)
    fields = add_rule(fields, x$save, x$command)

#    patterns = unlist(as.list(eval(parse(text = x$command))))
#print(patterns)

    write_yaml(fields, name_yml(x$save))
  })
}

#as.list(eval(parse(text = "f(x=12, y = mse_to_3)")))
