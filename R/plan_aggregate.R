#' @include placeholders.R single_step.R
NULL

#' @title Function \code{wh_aggregate}
#' @description Internal function to aggregate summaries
#' @export
#' @param type Character, type of summary
#' @param ... Names of summaries to aggregate
wh_aggregate = function(type, ...){
  arg = list(...)
  files = paste0(arg, ".rds")
  summaries = do.call(readRDS, files)
  names(summaries) = gsub(paste0("_", type, "$"), "", arg)
  summaries
}


#' @title Function \code{plan_aggregate}
#' @description Internal function to aggregate summaries
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character string, command to run
#' @param type Character string, type of summary to aggregate
#' @param summaries Names of summaries
plan_aggregate = function(sources, packages, type, summaries){
  depends = summaries[grep(paste0("_", type, "$"), summaries)]
  summary_str = paste(summaries, collpase = ", ")

  fields = list(
    sources = sources,
    packages = c(packages, "workflowHelper"),
    targets = list(
      all = list(depends = paste0(type, ".rds"))
    )
  )

  fields$targets[[paste0(type, ".rds")]] = 
    list(command = paste0("wh_aggregate(", type, ", ", summary_str, ")"))

  for(i in 1:length(depends))
    fields$targets[[names(depends)[i]]] = 
      list(command = paste0("readRDS(\"", depends[i], ".rds\")"))
}
