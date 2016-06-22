library(workflowHelper)

sources = strings(code.R)
packages = "rmarkdown"

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
  coef_table = do.call(I("rbind"), coef),
  coef.csv = write.csv(coef_table, target_name),
  mse_vector = unlist(mse),
  mse.pdf = ..plot.. <- hist(mse_vector, col = I("black")),
  report.md = ..knitr.. <- list(fig.height = 7, fig.align = "right"),
  report.html = render("report.md", quiet = TRUE)
)

begin = c("# This is my Makefile", "# Variables...")
plan_workflow(sources, packages, datasets, analyses, summaries, output, begin = begin)
