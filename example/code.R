# Code for each component of the analysis

# Generate datasets
poisson_dataset = function(file, n = 100){
  out = data.frame(x = rpois(n, 1), y = rpois(n, 5))
  saveRDS(out, file)
}

normal_dataset = function(file, n = 100){
  out = data.frame(x = rnorm(n, 1), y = rnorm(n, 5))
  saveRDS(out, file)
}

# Analyze each dataset
lm_analysis = function(file, dataset){
  dataset = readRDS(dataset)
  out = lm(y ~ x, data = dataset)
  saveRDS(out, file)
}

glm_analysis = function(file, dataset){
  dataset = readRDS(dataset)
  out = glm(y ~ x, data = dataset)
  saveRDS(out, file)
}

# Compute summaries
mse_summary = function(file, dataset, analysis){
  dataset = readRDS(dataset)
  analysis = readRDS(analysis)
  pred = predict(analysis)
  out = mean((pred - dataset$y)^2)
  saveRDS(out, file)
}

coef_summary = function(file, analysis){
  analysis = readRDS(analysis)
  out = coef(analysis)
  saveRDS(out, file)
}

# Aggregate the summaries together
aggregate_mse = function(file, ...){
  summaries = unlist(list(...))
  summaries = summaries[grep("_mse.rds$", summaries)]
  mse = sapply(summaries, readRDS)
  out = data.frame(file = summaries, mse = mse)
  saveRDS(out, file)
}

aggregate_coef = function(file, ...){
  summaries = unlist(list(...))
  summaries = summaries[grep("_coef.rds$", summaries)]
  coef = do.call(rbind, lapply(summaries, readRDS))
  out = data.frame(file = summaries, coef)
  saveRDS(out, file)
}

# Final output
mse_as_csv = function(){
  mse = readRDS("mse.rds")
  write.csv(mse, "mse.csv", row.names = FALSE)
}

plot_coef = function(){
  coef = readRDS("coef.rds")
  pdf("coef.pdf")
  plot(coef[,2:3])
  dev.off()
}
