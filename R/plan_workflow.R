#' @include single_step.R
NULL

#' @title Function \code{plan_workflow}
#' @description Plan a simulation study workflow or something similar. Produces a makefile 
#' so that you can run or resume you workflow with `make` or `make -j <whatever>` for
#' parallelization.
#' @export
#' @param sources Character vector of paths to the files containing your R code 
#' (*.R and *.r files) along with external packages (no file extension).
#' @param datasets Named character vector of commands to generate datasets.
#' @param analyses Named character vector of commands to analyze the datasets.
#' @param summaries Named character vector of commands to condense the data and 
#' analyses into small summaries.
#' @param aggregates Character vector stating commands to generate aggregates files
#' from the summaries. Using the datasets and analyses is also possible, but it
#' may be slow. Execution of the commands may be in parallel.
#' @param output Named character vector, commands for general output. Unlike the 
#' other command vectors, the names here need not denote rds files. However, they 
#' should have the appropriate file extensions.
plan_workflow = function(sources, datasets = NULL, analyses = NULL, summaries = NULL, aggregates = NULL, output = NULL){

  isSource = grepl("\\.[rR]$", sources)
  packages = sources[!isSource]
  sources = sources[isSource]
  stages = list()

  if(length(datasets)) for(i in 1:length(datasets)){
    step = plan_dataset(sources, packages, datasets[i], names(datasets)[i])
    stages[["datasets"]] = c(stages[["datasets"]], step)
    if(length(analyses)) for(j in 1:length(analyses)){
      step = plan_analysis(sources, packages, analyses[j], names(datasets)[i], names(analyses)[j])
      stages[["analyses"]] = c(stages[["analyses"]], step)
      if(length(summaries)) for(k in 1:length(summaries)){
        step = plan_summary(sources, packages, summaries[k], 
          names(datasets)[i], names(analyses)[j], names(summaries)[k])
        stages[["summaries"]] = c(stages[["summaries"]], step)
      }
    }
  }

  if(length(aggregates)) for(i in 1:length(aggregates)){
    step = plan_aggregate(sources, packages, aggregates[i], names(aggregates)[i], 
      summaries = stages$summaries)
    stages[["aggregates"]] = c(stages[["aggregates"]], step)
  }

  if(length(output)) for(i in 1:length(output)){
    step = plan_output(sources, packages, output[i], names(output)[i], stages$summaries)
    stages[["output"]] = c(stages[["output"]], step)
  }

  if(length(stages)){
    write_makefile(stages)
  } else {
    message("Nothing to do. No Makefile written.")
  }
}