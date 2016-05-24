#' @include utils.R
NULL

#' @title Internal function
#' @description Internal function
#' @export
#' @return A sanatized data frame.
#' @param datasets Data frame of information targets to generate.
#' @param analyses Data frame of information targets to generate.
#' @param summaries Data frame of information targets to generate.
parse_summaries = function(datasets = NULL, analyses = NULL, summaries = NULL){
  if(is.null(datasets) | is.null(analyses) | is.null(summaries)) return()
  summaries = expand_grid_df(
    data.frame(dataset = datasets$save),
    data.frame(analysis = analyses$save),
    summaries
  )  
  summaries$save = apply(summaries[,1:3], 1, paste, collapse = "_")
  summaries$analysis = apply(summaries[,1:2], 1, paste, collapse = "_")
  summaries$command = apply(summaries, 1, function(x){
    for(item in c("dataset", "analysis"))
      x["command"] = gsub(macro(item), name_load(x[item]), x["command"])
    x["command"]
  })
  summaries
}
