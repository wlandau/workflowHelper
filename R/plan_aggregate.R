#' @include placeholders.R
NULL

#' @title Function \code{plan_aggregate}
#' @description Internal function to aggregate summaries
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param type Character string, type of summary to aggregate
#' @param summaries Names of summaries
plan_aggregate = function(sources, packages, type, summaries){
  save_file = paste0(type, ".rds")
  save_object = paste0(type, placeholders()["save"])
  depends = summaries[grep(paste0("_", type, "$"), summaries)]
  args = names(depends) = paste0(depends, placeholders()["load"])
  args = paste(args, collapse = ", ")

  fields = list(
    sources = sources,
    packages = c(packages, "workflowHelper"),
    targets = list(
      all = list(depends = save_file)
    )
  )

  fields$targets[[save_file]] = list(command = paste0("saveRDS(", save_object, ", \"", save_file, "\"", ")"))
  fields$targets[[save_object]] = list(command = paste0("list(", args, ")"))

  for(i in 1:length(depends))
    fields$targets[[names(depends)[i]]] = 
      list(command = paste0("readRDS(\"", depends[i], ".rds\")"))
  
  write_yaml(fields, paste0(type, ".yml"))
}
