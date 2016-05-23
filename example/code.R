# Code for each component of the analysis

# Generate datasets
poisson_dataset = function(n = 100){
  data.frame(x = rpois(n, 1), y = rpois(n, 5))
}

normal_dataset = function(n = 100){
  data.frame(x = rnorm(n, 1), y = rnorm(n, 5))
}

# Analyze each dataset
lm_analysis = function(dataset){
  out = lm(y ~ x, data = dataset)
}

glm_analysis = function(dataset){
  glm(y ~ x, data = dataset)
}

# Compute summaries
mse_summary = function(dataset, analysis){
  pred = predict(analysis)
  mean((pred - dataset$y)^2)
}

coef_summary = function(analysis){
  coef(analysis)
}

# Aggregate the summaries together
aggregate_mse = function(...){
  summaries = list(...)
  is_mse = sapply(summaries, length) == 1
  unlist(summaries[is_mse])
}

aggregate_coef = function(save, ...){
  summaries = list(...)
  is_coef = sapply(summaries, length) > 1
  do.call(rbind, summaries[is_coef])
}

# Final output
mse_as_csv = function(file){
  mse = matrix(readRDS(file), ncol = 1)
  write.csv(mse, "mse.csv", row.names = FALSE)
}

# You may hard-code an output file for final output.
plot_coef = function(file){
  coef = do.call(rbind, readRDS(file))
  pdf("coef.pdf")
  plot(coef)
  dev.off()
}
