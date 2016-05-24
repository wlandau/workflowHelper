#' @include expand_grid_df.R
NULL

#' @title Internal function
#' @description Internal function
#' @export
#' @return A sanatized data frame
#' @param datasets Data frame of information targets to generate.
#' @param analyses Data frame of information targets to generate.
parse_analyses = function(datasets = NULL, analyses = NULL){
  if(is.null(datasets) | is.null(analyses)) return()
  analyses = expand_grid_df(data.frame(dataset = datasets$save), analyses)
  analyses$save = paste(datasets$save, analyses$save, sep = "_")
  analyses$command = apply(analyses, 1, function(x){
    replacement = paste0(x["dataset"], macro("load"))
    gsub(macro("dataset"), replacement, x["command"])
  })
  analyses
}
