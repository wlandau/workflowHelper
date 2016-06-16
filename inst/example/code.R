# Code for each component of the example analysis

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
  dataset$y = dataset$y + 1 # force a difference between glm and lm
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

# Final output
mse_plot = function(x){
  mse = unlist(x)
  pdf("mse.pdf")
  hist(mse, col = "black")
  dev.off()
}

coef_table = function(x){
  tab = do.call(rbind, x)
  write.csv(tab, "coef.csv")
}
