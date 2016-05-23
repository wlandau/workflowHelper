#' @title Function \code{single_step}
#' @description Plans a stage of the workflow. Utility function of \code{plan_workflow}.
#' @seealso \code{plan_workflow}
#' @export
#' @param sources Character vector of paths to the files containing your R code.
#' @param packages Character vector of packages that your code depends on.
#' @param command dependsd character vector of commands to run.
#' @param root root of file
#' @param dataset name of RDS dataset file
#' @param analysis name of RDS analysis file
#' @param summaries Character vector, names of RDS summary files
#' @param append_rds logical, whether to append a \code{.rds} file extension to the output
single_step = function(sources, packages, command, root, dataset = "", analysis = "", summaries = "",
append_rds = TRUE){
  FILE = "__FILE__"
  DATASET = "__DATASET__"
  ANALYSIS = "__ANALYSIS__"
  SUMMARIES = "__SUMMARIES__"

  depends = paste0(root, ifelse(append_rds, ".rds", ""))
  yaml = paste0(root, ".yml")

  command = gsub(FILE, paste0("\"", depends, "\""), command)
  command = gsub(DATASET, paste0("\"", dataset, "\""), command)
  command = gsub(ANALYSIS, paste0("\"", analysis, "\""), command)

  summaries = paste0("\"", summaries, "\"")
  summaries = paste(summaries, collapse = ", ")
  command = gsub(SUMMARIES, summaries, command)

  fields = list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = depends)
    )
  )
  fields$targets[[depends]] = list(command = command)
  write_yaml(fields, yaml)
}
