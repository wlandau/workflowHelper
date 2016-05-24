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
    save_file = name_rds(x$save)
    save_object = name_save(x$save)
    fields = init_fields(sources, packages, save_file)
    fields = add_rule(fields, save_file, name_saveRDS(save_object, save_file))
    fields = add_rule(fields, save_object, x$command)
    for(item in c("dataset", "analysis", "summary")) if(item %in% colnames(x))
      fields = add_rule(fields, name_load(x[[item]]), name_readRDS(name_rds(x[[item]])))
    write_yaml(fields, name_yml(x$save))
  })
}
