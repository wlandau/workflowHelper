#' @title Internal function
#' @description Internal function
#' @export
#' @return The selected macro.
#' @param arg Character, name of macro to fetch.
macro = function(arg){
  c(
    dataset = "..DATASET..",
    analysis = "..ANALYSIS..",
    save = "..SAVE..",
    load = "..LOAD..",
    cache = "..CACHE.."
  )[arg]
}
