#' @include single_step.R
NULL

#' @title Function \code{plan_workflow}
#' @description Plan a simulation study workflow or something similar. Produces a makefile 
#' so that you can run or resume you workflow with `make` or `make -j <whatever>` for
#' parallelization.
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
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
plan_workflow = function(sources, packages = NULL, datasets = NULL, analyses = NULL, summaries = NULL, aggregates = NULL, output = NULL){

  dataset_files = analysis_files = summary_files = c()
  if(length(datasets)) for(i in 1:length(datasets)){
    dataset = paste0(names(datasets)[i], ".rds")
    dataset_files = c(dataset_files, dataset)
    single_step(sources, packages, datasets[i], names(datasets)[i])
    if(length(analyses)) for(j in 1:length(analyses)){
      root = paste(names(datasets)[i], names(analyses)[j], sep = "_")
      analysis = paste0(root, ".rds")
      analysis_files = c(analysis, analysis_files)
      single_step(sources, packages, analyses[j], root, dataset)
      if(length(summaries)) for(k in 1:length(summaries)){
        root = paste(names(datasets)[i], names(analyses)[j], names(summaries)[k], sep = "_")
        summary_files = c(summary_files, paste0("", root, ".rds"))
        single_step(sources, packages, summaries[k], root, dataset, analysis)
      }
    }
  }

  if(length(aggregates)) for(i in 1:length(aggregates))
    single_step(sources, packages, aggregates[i], names(aggregates)[i], summaries = summary_files)

  if(length(output)) for(i in 1:length(output))
    single_step(sources, packages, output[i], names(output)[i], append_rds = FALSE)

  stages = list(
    gsub(".rds", "", dataset_files),
    gsub(".rds", "", analysis_files),
    gsub(".rds", "", summary_files), 
    names(aggregates),
    names(output)
  )

  stages = stages[!sapply(stages, is.null)]
  stages = stages[sapply(stages, function(x){any(nchar(x) > 0)})]
  if(length(stages)){
    write_makefile(stages)
  } else {
    message("Nothing to do. No Makefile written.")
  }
}