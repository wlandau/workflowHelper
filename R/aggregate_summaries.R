#' @title Internal function
#' @description Internal function
#' @export 
#' @return A named list
#' @param names Names of the output list.
#' @param values Values of the output list
aggregate_summaries = function(names, values){
  names(values) = names
  values
}
