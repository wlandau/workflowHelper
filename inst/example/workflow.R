library(workflowHelper)

sources = strings(code.R)
packages = strings(MASS)
# packages = strings(MASS, rmarkdown, tools) # Uncomment before building pdf/html.

datasets = commands(
  normal16 = normal_dataset(n = 16),
  poisson32 = poisson_dataset(n = 32),
  poisson64 = poisson_dataset(n = 64)
)

# For 4 replicates of each kind of dataset, 
# assign datasets = reps(datasets, 4)

analyses = commands(
  linear = linear_analysis(..dataset..),
  quadratic = quadratic_analysis(..dataset..)
)

summaries = commands(
  mse = mse_summary(..dataset.., ..analysis..),
  coef = coefficients_summary(..analysis..)
)

output = commands(
  coef_table = do.call(I("rbind"), coef),
  coef.csv = write.csv(coef_table, target_name),
  mse_vector = unlist(mse)
)

plots = commands(
  mse.pdf = hist(mse_vector, col = I("black"))
)

reports = commands(
  markdown.md = list("poisson32", "coef_table", "coef.csv"), # dependencies
  latex.tex = TRUE # no dependencies here
#  markdown.html = render("markdown.md", quiet = TRUE, clean = FALSE),
#  latex.pdf = texi2pdf("latex.tex", clean = FALSE)
)

begin = c("# This is my Makefile", "# Variables...")
plan_workflow(sources, packages, datasets, analyses, summaries, output, plots, reports = reports, begin = begin)
