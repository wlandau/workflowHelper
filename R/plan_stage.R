#' @include utils.R
NULL

#' @title Internal function
#' @description Internal function
#' @export
#' @param df Data frame for producing targets.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_stage = function(df, sources, packages){
  ddply(df, colnames(df), function(x){
    fields = init_fields(sources, packages, x$save)
    fields = add_rule(fields, x$save, x$command)
    for(item in c("dataset", "analysis", "summary"))
      if(item %in% colnames(x) & grepl(name_load(x[[item]]), x$command))
        fields = add_rule(fields, name_load(x[[item]]), name_recall(x[[item]]))
    write_yaml(fields, name_yml(x$save))
  })
}
