parse_aggregates = function(aggregates, summaries){
  ddply(aggregates, colnames(aggregates), function(x){
    pattern = paste0("_", x$save, "$")
    depends = sort(summaries$save[grep(pattern, summaries$save)])
    list_names = gsub(pattern, "", depends)
    x$command = name_list(paste(list_names, "=", depends))
    x
  })
}

parse_analyses = function(datasets = NULL, analyses = NULL){
  if(is.null(datasets) | is.null(analyses)) return()
  analyses = expand_grid_df(data.frame(dataset = datasets$save), analyses)
  analyses$save = paste(datasets$save, analyses$save, sep = "_")
  analyses$command = apply(analyses, 1, function(x)
    gsub(macro("dataset"), x["dataset"], x["command"], ignore.case=T))
  analyses
}

parse_summaries = function(datasets = NULL, analyses = NULL, summaries = NULL){
  if(is.null(datasets) | is.null(analyses) | is.null(summaries)) return()
  summaries = expand_grid_df(
    data.frame(dataset = datasets$save),
    data.frame(analysis = analyses$save),
    summaries
  )  
  summaries$save = apply(summaries[,1:3], 1, paste, collapse = "_")
  summaries$analysis = apply(summaries[,1:2], 1, paste, collapse = "_")
  summaries$command = apply(summaries, 1, function(x){
    for(item in c("dataset", "analysis"))
      x["command"] = gsub(macro(item), x[item], x["command"], ignore.case=T)
    x["command"]
  })
  summaries
}

parse_plots = function(plots){
  if(is.null(plots)) return()
  plots$plot = TRUE
  plots
}

parse_stages = function(datasets, analyses, summaries, aggregates, output, plots, reports){
  stages = list(datasets = datasets, analyses = analyses, summaries = summaries, 
     aggregates = summaries, output = output, plots = plots, reports = reports)
  stages = stages[!sapply(stages, is.null)]
  if(!length(stages)) stop("no work to be done.")
  stages = lapply(stages, function(x) 
    data.frame(save = names(x), command = x, stringsAsFactors = F))
  stages$summaries = parse_summaries(stages$datasets, stages$analyses, stages$summaries)
  stages$analyses = parse_analyses(stages$datasets, stages$analyses)
  stages$aggregates = parse_aggregates(stages$aggregates, stages$summaries)
  stages$plots = parse_plots(stages$plots)
  stages
}
