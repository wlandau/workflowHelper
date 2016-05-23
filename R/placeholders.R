#' @title Function \code{placeholders}
#' @description Placeholder placeholders for commands.
#' @details These are placeholders to use when you're writing 
#' commands to generate data, run analyses, etc. They stand in 
#' for files, and they are for 
#' situations where the program can infer the correct file to
#' load, the correct file to save, etc. 
#' The save and load macros are for internal use only.
placeholders = function(){
  c(
    dataset = "..DATASET..",
    analysis = "..ANALYSIS..",
    save = "..SAVE..",
    load = "..LOAD.."
  )
}
