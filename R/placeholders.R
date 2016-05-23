#' @title Function \code{placeholders}
#' @description Placeholder placeholders for commands.
#' @details These are placeholders to use when you're writing 
#' commands to generate data, run analyses, etc. They stand in 
#' for files, and they are for 
#' situations where the program can infer the correct file to
#' load, the correct file to save, etc. 
#' The save placeholder is always available, and it stands for the
#' file to be saved. Similarly, there is a dataset placeholder for when
#' you are analyzing data or summarizing analyses, an analysis placeholder
#' for summarizing analyses, and a summaries placeholder for aggregating
#' summaries of analyses
#' @export
placeholders = function(){
  c(
    save = "__SAVE__",
    dataset = "__DATASET__",
    analysis = "__ANALYSIS__",
    summaries = "__SUMMARIES__"
  )
}
