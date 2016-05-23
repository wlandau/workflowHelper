#' @title Function \code{single_step}
#' @description Internal function to plan a stage of the workflow. 
#' Utility function of \code{plan_workflow}.
#' @seealso \code{plan_workflow}
#' @export
#' @return list of fields for the YAML file
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command Character, command to run.
#' @param save Character, target file to save
#' @param depends named character vector of file dependencies
#' @param replacements Named character vector, substitutions to make in command placeholders
single_step = function(sources, packages, command, save, depends = NULL, replacements = NULL){
  save_file = paste0(save, ".rds")
  save_object = paste0(save, placeholders()["save"])

  if(!is.null(replacements)) for(i in 1:length(replacements))
    command = gsub(names(replacements)[i], replacements[i], command)

  fields = list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = save_file)
    )
  )

  fields$targets[[save_file]] = 
    list(command = paste0("saveRDS(", save_object, ", \"", save_file, "\")"))
  fields$targets[[save_object]] = list(command = command)

  if(length(depends)) for(i in 1:length(depends))
    fields$targets[[names(depends)[i]]] = 
      list(command = paste0("readRDS(\"", depends[i], ".rds\")"))

  write_yaml(fields, paste0(save, ".yml"))
  fields
}
