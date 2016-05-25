#' @title Internal function
#' @description Internal function
#' @export
#' @param summaries Data frame of information about summaries to aggregate.
#' @param aggregates Data frame about output files.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_aggregates = function(summaries, aggregates, sources, packages){
  ddply(aggregates, colnames(aggregates), function(x){
    pattern = paste0("_", x$save, "$")
    items = grep(pattern, summaries$save)
    depends = summaries$save[items]
    fields = init_fields(sources, packages, x$save)
    fields = add_rule(fields, x$save, name_recall(depends))
    write_yaml(fields, name_yml(x$save))
  })
}
