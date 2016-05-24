add_rule = function(fields, name, command){
  fields$targets[[name]] = list(command = command)
  fields
}

expand_grid_df = function(...) 
  Reduce(function(...) merge(..., by = NULL), list(...))

init_fields = function(sources, packages, save){
  list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = save)
    )
  )
}

macro = function(arg){
  c(
    dataset = "..DATASET..",
    analysis = "..ANALYSIS..",
    save = "..SAVE..",
    load = "..LOAD..",
    cache = "cache"
  )[arg]
}

name_list = function(items, quoted = F){
  if(quoted) items = paste0("\"", items, "\"")
  items = paste(items, collapse = ", ")
  paste0("list(", items, ")")
}

name_load = function(items){
  paste0(items, macro("load"))
}

name_readRDS = function(file){
  paste0("readRDS(\"", file, "\"", ")")
}

name_rds = function(items, cache = T){
  folder = ifelse(cache, new_dir(macro("cache")), "")
  paste0(folder, items, ".rds")
}

name_save = function(items){
  paste0(items, macro("save"))
}

name_saveRDS = function(object, file){
  paste0("saveRDS(", object, ", \"", file, "\"", ")")
}

name_yml = function(items){
  folder = "" # new_dir("yaml")
  paste0(folder, items, ".yml")
}

new_dir = function(path){
  split = unlist(strsplit(path, "/"))
  if(length(split)) for(i in 1:length(split)){
    x = paste(split[1:i], collapse = "/")
    if(!file.exists(x)) dir.create(x)
  }
  if(substr(path, nchar(path), nchar(path)) != "/") path = paste0(path, "/")
  path
}
