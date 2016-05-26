library(workflowHelper)

# R files with your code (ending in .R or .r) and packages
sources = strings(code.R, MASS)

# Generate the data
datasets = commands(
  poisson100 = poisson_dataset(n = 100),
  normal100 = normal_dataset(n = 100),
  normal1000 = normal_dataset(n = 1000)
)

# Analyze each dataset
analyses = commands(
  lm = lm_analysis(..DATASET..),
  glm = glm_analysis(..DATASET..)
)

# Summarize each analysis and aggregate the summaries together
summaries = commands(
  mse = mse_summary(..DATASET.., ..ANALYSIS..),
  coef = coef_summary(..ANALYSIS..)
)

# Final output.
output = commands(
  mse.pdf = mse_plot(),
  coef.csv = coef_table()
)

begin = c("# This is my Makefile", "# Variables...")

plan_workflow(sources, datasets, analyses, summaries, output, begin)
