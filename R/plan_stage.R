#' @title Internal function
#' @description Internal function
#' @export
#' @param df Data frame for producing targets.
#' @param sources Character vector of R code files to load.
#' @param packages Character vector of R packages to load.
plan_stage = function(df, sources, packages){
  ddply(df, colnames(df), function(x){
    save_file = paste0(x$save, ".rds")
    save_object = paste0(x$save, macro("save"))

    fields = list(
      sources = sources,
      packages = packages,
      targets = list(
        all = list(depends = save_file)
      )
    )

    fields$targets[[save_file]] = 
      list(command = paste0("saveRDS(", save_object, ", \"", save_file, "\")"))
    fields$targets[[save_object]] = list(command = x$command)

    for(item in c("dataset", "analysis", "summary")) if(item %in% colnames(x)){
      depends = paste0(x[[item]], macro("load"))
      fields$targets[[depends]] = list(command = paste0("readRDS(\"", x[[item]], ".rds\")"))
    }

    write_yaml(fields, paste0(x$save, ".yml"))
  })
}
