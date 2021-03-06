expand_grid_df = function(...) 
  Reduce(function(...) merge(..., by = NULL), list(...))

init_fields = function(sources, packages, depends){
  list(
    sources = sources,
    packages = packages,
    targets = list(
      all = list(depends = depends)
    )
  )
}

knitr_target = function(row, stages){
  row = as.list(row)
  row$depends = setdiff(names(stages), "reports")
  if(grepl("\\.(md|tex)$", row$save)){
    tryCatch(dep <- eval(parse(text = row$command)),
      error = function(e) assign("dep", row$command, envir = parent.env(environment())))
    row$command = NULL
    row$knitr = TRUE
    if(length(dep))
      if(is.list(dep) | is.character(dep)) 
        row$depends = c(row$depends, unlist(dep))
  }
  row
}

list_targets = function(dataframe, stage, stages){
  out = c()
  for(i in 1:nrow(dataframe)){
    row = dataframe[i,]
    if(stage == "reports") row = knitr_target(row, stages)
    keep = !sapply(row, function(x) is.null(x) | identical(x, F)) &
      names(row) %in% c("command", "depends", "plot", "knitr")
    out[[dataframe$save[i]]] = row[keep]
  }
  out
}

macro = function(arg){
  c(
    dataset = "\\.\\.dataset\\.\\.",   
    analysis = "\\.\\.analysis\\.\\."
  )[arg]
}

name_list = function(items, quoted = F){
  if(quoted) items = paste0("\"", items, "\"")
  items = sort(items)
  items = paste(items, collapse = ", ")
  paste0("list(", items, ")")
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
