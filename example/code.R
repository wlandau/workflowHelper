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
plot_mse = function(){
 mse = unlist(recall(mse))
 pdf("mse.pdf")
 hist(mse, col = "black")
 dev.off()
}

save_coef = function(){
  coef = do.call(rbind, recall(coef))
  write.csv(coef, "coef.csv")
}
