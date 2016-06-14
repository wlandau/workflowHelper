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
  lm = lm_analysis(..daTASEt..),
  glm = glm_analysis(..DataSet..)
)

# Summarize each analysis and aggregate the summaries together
summaries = commands(
  mse = mse_summary(..dAtAseT.., ..anALYsis..),
  coef = coef_summary(..AnAlYsIs..)
)

# Final output.
output = commands(
  mse.pdf = mse_plot(mse),
  coef.csv = coef_table(coef)
)

begin = c("# This is my Makefile", "# Variables...")
plan_workflow(sources, packages, datasets, analyses, summaries, output, begin = begin,
  makefile = NULL, remakefile = "remake3.yml")
