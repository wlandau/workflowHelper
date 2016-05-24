#' @include aggregate_summaries.R utils.R
NULL

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
    depends = summaries$save[grep(paste0("_", x$save, "$"), summaries$save)]
    names(depends) = name_load(depends)
    values = paste0("values_", x$save)
    names = paste0("names_", x$save)
    values_command = name_list(names(depends))
    names_command = name_list(name_rds(depends), quoted = T)
    aggregate_command = paste0("aggregate_summaries(", names, ", ", values, ")")

    fields = init_fields(sources, c(packages, "workflowHelper"), save_file)
    fields = add_rule(fields, save_file, name_saveRDS(save_object, save_file))
    fields = add_rule(fields, save_object, aggregate_command)
    fields = add_rule(fields, names, names_command)
    fields = add_rule(fields, values, values_command)
    for(i in 1:length(depends))
      fields = add_rule(fields, names(depends)[i], name_readRDS(name_rds(depends[i])))
  
    write_yaml(fields, name_yml(x$save))
  })
}
