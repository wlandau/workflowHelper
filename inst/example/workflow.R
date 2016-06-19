library(workflowHelper)

sources = strings(code.R)
packages = "MASS"

# Generate the data
datasets = commands(
  poisson100 = poisson_dataset(n = 100),
  normal100 = normal_dataset(n = 100),
  normal1000 = normal_dataset(n = 1000) 
)

# For 4 replicates of each kind of dataset, 
# assign datasets = reps(datasets, 4)

# Analyze each dataset
analyses = commands(
  lm = lm_analysis(..dataset..),
  glm = glm_analysis(..dataset..)
)

# Summarize each analysis and aggregate the summaries together
summaries = commands(
  mse = mse_summary(..dataset.., ..analysis..),
  coef = coef_summary(..analysis..)
)

# Final output.
output = commands(
  mse.pdf = ..plot.. <- mse_plot(mse),
  coef.csv = coef_table(coef),
  report.md = ..knitr..
)

begin = c("# This is my Makefile", "# Variables...")
plan_workflow(sources, packages, datasets, analyses, summaries, output, begin = begin)
