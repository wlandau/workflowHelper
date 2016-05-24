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

# Final output
mse_as_csv = function(file){
 mse = unlist(readRDS(file))
 write.csv(data.frame(file = names(mse), mse = mse), "mse.csv", row.names = F)
}

plot_coef = function(file){
  pdf("coef.pdf")
  coef = do.call(rbind, readRDS("coef.rds"))
  plot(coef)
  dev.off()
}
