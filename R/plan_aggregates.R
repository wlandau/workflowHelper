#' @title Internal function
#' @description Internal function
#' @export
#' @param summaries Data frame of information about summaries to aggregate.
#' @param aggregates Data frame about output files.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_aggregates = function(summaries, aggregates, sources, packages){
  ddply(aggregates, colnames(aggregates), function(x){
    save_file = name_rds(x$save, cache = F)
    save_object = name_save(x$save)
    pattern = paste0("_", x$save, "$")
    depends = summaries$save[grep(pattern, summaries$save)]
    list_names = gsub(pattern, "", depends)
    command = name_list(paste(list_names, "=", name_load(depends)))
    fields = init_fields(sources, packages, save_file)
    fields = add_rule(fields, save_file, name_saveRDS(save_object, save_file))
    fields = add_rule(fields, save_object, command)
    for(i in 1:length(depends))
      fields = add_rule(fields, name_load(depends[i]), name_readRDS(name_rds(depends[i])))
    write_yaml(fields, name_yml(x$save))
  })
}
