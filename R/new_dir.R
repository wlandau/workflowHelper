#' @title Function \code{new_dir}
#' @description make a new directory for storing simulations and results
#' @export
#' @return directory name
#' @param path path to directory
new_dir = function(path){
  split = unlist(strsplit(path, "/"))
  if(length(split)) for(i in 1:length(split)){
    x = paste(split[1:i], collapse = "/")
    if(!file.exists(x)) dir.create(x)
  }
  if(substr(path, nchar(path), nchar(path)) != "/") path = paste0(path, "/")
  path
}
