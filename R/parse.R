#' @title Internal function
#' @description Internal function
#' @export
#' @param aggregates Data frame about output files.
#' @param summaries Data frame of information about summaries to aggregate.
parse_aggregates = function(aggregates, summaries){
  ddply(aggregates, colnames(aggregates), function(x){
    pattern = paste0("_", x$save, "$")
    depends = sort(summaries$save[grep(pattern, summaries$save)])
    list_names = gsub(pattern, "", depends)
    x$command = name_list(paste(list_names, "=", depends))
    x
  })
}

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
  analyses$command = apply(analyses, 1, function(x)
    gsub(macro("dataset"), x["dataset"], x["command"]))
  analyses
}

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
      x["command"] = gsub(macro(item), x[item], x["command"])
    x["command"]
  })
  summaries
}
