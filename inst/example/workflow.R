library(workflowHelper)

sources = strings(code.R)
packages = strings(MASS)
# packages = strings(MASS, rmarkdown, tools) # Uncomment before building pdf/html.

datasets = commands(
  poisson100 = poisson_dataset(n = 100),
  normal100 = normal_dataset(n = 100),
  normal1000 = normal_dataset(n = 1000) 
)

# For 4 replicates of each kind of dataset, 
# assign datasets = reps(datasets, 4)

analyses = commands(
  lm = lm_analysis(..dataset..),
  glm = glm_analysis(..dataset..)
)

summaries = commands(
  mse = mse_summary(..dataset.., ..analysis..),
  coef = coef_summary(..analysis..)
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
  markdown.md = list(fig.height = 6, fig.align = "right"),
  latex.tex = TRUE
#  markdown.html = render("markdown.md", quiet = TRUE, clean = FALSE),
#  latex.pdf = texi2pdf("latex.tex", clean = FALSE)
)

begin = c("# This is my Makefile", "# Variables...")
plan_workflow(sources, packages, datasets, analyses, summaries, output, plots, reports = reports, begin = begin)
