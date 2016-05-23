library(workflowHelper)
library(parallelRemake)

# R files with your code (ending in .R or .r) and packages
sources = c("code.R", "MASS")

# Generate the data
datasets = c(
  poisson100 = "poisson_dataset(__SAVE__, n = 100)",
  normal100 = "normal_dataset(__SAVE__, n = 100)",
  normal1000 = "normal_dataset(__SAVE__, n = 1000)"
)

# Analyze each dataset
analyses = c(
  lm = "lm_analysis(__SAVE__, __DATASET__)",
  glm = "glm_analysis(__SAVE__, __DATASET__)"
)

# Summarize each analysis
summaries = c(
  mse = "mse_summary(__SAVE__, __DATASET__, __ANALYSIS__)",
  coef = "coef_summary(__SAVE__, __ANALYSIS__)"
)

# Aggregate the summaries together
aggregates = c(
  mse = "aggregate_mse(__SAVE__, __SUMMARIES__)",
  coef = "aggregate_coef(__SAVE__, __SUMMARIES__)"
)

# Final output.
output = c(
  mse.csv = "mse_as_csv(__SAVE__)",
  coef.pdf = "plot_coef()"
)

plan_workflow(sources, datasets, analyses, summaries, aggregates, output)

