#' @title Utility function to aggregate summaries
#' @description Utility function to aggregate summaries
#' @export
#' @param names Names of files that the summaries came from
#' @param values Summaries to collect.
aggregate_summaries = function(names, values){
  names(values) = names
  values
}
