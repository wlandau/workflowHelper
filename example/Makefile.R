library(workflowHelper)
library(parallelRemake)

# R files with your code (ending in .R or .r) and packages
sources = c("code.R", "MASS")

# Generate the data
datasets = c(
  poisson100 = "poisson_dataset(n = 100)",
  normal100 = "normal_dataset(n = 100)",
  normal1000 = "normal_dataset(n = 1000)"
)

# Analyze each dataset
analyses = c(
  lm = "lm_analysis(..DATASET..)",
  glm = "glm_analysis(..DATASET..)"
)

# Summarize each analysis
summaries = c(
  mse = "mse_summary(..DATASET.., ..ANALYSIS..)",
  coef = "coef_summary(..ANALYSIS..)"
)

# Aggregate the summaries together
aggregates = c(
  mse = "aggregate_mse(..SUMMARIES..)",
  coef = "aggregate_coef(..SUMMARIES..)"
)

# Final output.
output = c(
  mse.csv = "mse_as_csv()",
  coef.pdf = "plot_coef()"
)

plan_workflow(sources, datasets, analyses, summaries, aggregates, output)

