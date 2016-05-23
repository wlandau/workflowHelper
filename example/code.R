# Code for each component of the analysis

# Generate datasets
poisson_dataset = function(save, n = 100){
  out = data.frame(x = rpois(n, 1), y = rpois(n, 5))
  saveRDS(out, save)
}

normal_dataset = function(save, n = 100){
  out = data.frame(x = rnorm(n, 1), y = rnorm(n, 5))
  saveRDS(out, save)
}

# Analyze each dataset
lm_analysis = function(save, dataset){
  dataset = readRDS(dataset)
  out = lm(y ~ x, data = dataset)
  saveRDS(out, save)
}

glm_analysis = function(save, dataset){
  dataset = readRDS(dataset)
  out = glm(y ~ x, data = dataset)
  saveRDS(out, save)
}

# Compute summaries
mse_summary = function(save, dataset, analysis){
  dataset = readRDS(dataset)
  analysis = readRDS(analysis)
  pred = predict(analysis)
  out = mean((pred - dataset$y)^2)
  saveRDS(out, save)
}

coef_summary = function(save, analysis){
  analysis = readRDS(analysis)
  out = coef(analysis)
  saveRDS(out, save)
}

# Aggregate the summaries together
aggregate_mse = function(save, ...){
  summaries = unlist(list(...))
  summaries = summaries[grep("_mse.rds$", summaries)]
  mse = sapply(summaries, readRDS)
  out = data.frame(save = summaries, mse = mse)
  saveRDS(out, save)
}

aggregate_coef = function(save, ...){
  summaries = unlist(list(...))
  summaries = summaries[grep("_coef.rds$", summaries)]
  coef = do.call(rbind, lapply(summaries, readRDS))
  out = data.frame(save = summaries, coef)
  saveRDS(out, save)
}

# Final output
mse_as_csv = function(save){
  mse = readRDS("mse.rds")
  write.csv(mse, save, row.names = FALSE)
}

# You may hard-code an output file for final output.
plot_coef = function(){
  coef = readRDS("coef.rds")
  pdf("coef.pdf")
  plot(coef[,2:3])
  dev.off()
}
