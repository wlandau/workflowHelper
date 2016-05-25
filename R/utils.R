add_rule = function(fields, name, command){
  fields$targets[[name]] = list(command = command)
  fields
}

expand_grid_df = function(...) 
  Reduce(function(...) merge(..., by = NULL), list(...))

init_fields = function(sources, packages, save){
  list(
    sources = sources,
    packages = c(packages, "workflowHelper"),
    targets = list(
      all = list(depends = save)
    )
  )
}

name_recall = function(x){
  out = paste0("I(\"", x, "\")")
  out = paste(out, collapse = ", ")
  paste0("recall(", out, ")")
}

macro = function(arg){
  c(
    dataset = "..DATASET..",
    analysis = "..ANALYSIS..",
    load = "..LOAD.."
  )[arg]
}

name_load = function(items){
  paste0(items, macro("load"))
}

name_yml = function(items){
  paste0(items, ".yml")
}
