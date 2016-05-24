#' @title Internal function
#' @description Internal function
#' @export
#' @param summaries Data frame of information about summaries to aggregate.
#' @param aggregates Data frame about output files.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_aggregates = function(summaries, aggregates, sources, packages){
  ddply(aggregates, colnames(aggregates), function(x){
    save_file = paste0(x$save, ".rds")
    save_object = paste0(x$save, macro("save"))
    depends = summaries$save[grep(paste0("_", x$save, "$"), summaries$save)]
    values = names(depends) = paste0(depends, macro("load"))
    values = paste(values, collapse = ", ")
    names = paste0("\"", depends, ".rds\"")
    names = paste(names, collapse = ", ")
    values_object = paste("values", x$save, sep = "_")
    names_object = paste("names", x$save, sep = "_")
    
    fields = list(
      sources = sources,
      packages = c(packages, "workflowHelper"),
      targets = list(
        all = list(depends = save_file)
      )
    )

    fields$targets[[save_file]] = 
      list(command = paste0("saveRDS(", save_object, ", \"", save_file, "\"", ")"))
    fields$targets[[save_object]] = 
      list(command = paste0("aggregate_summaries(", names_object, ", ", values_object, ")"))
    fields$targets[[names_object]] = list(command = paste0("list(", names,")"))
    fields$targets[[values_object]] = list(command = paste0("list(", values,")"))

    for(i in 1:length(depends))
      fields$targets[[names(depends)[i]]] = 
        list(command = paste0("readRDS(\"", depends[i], ".rds\")"))
  
    write_yaml(fields, paste0(x$save, ".yml"))
  })
}
