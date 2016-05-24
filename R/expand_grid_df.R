#' @title Internal function
#' @description Internal function
#' @export
#' @return A single merged data frame.
#' @param ... Data frames to merge.
expand_grid_df = function(...) 
  Reduce(function(...) merge(..., by = NULL), list(...))
