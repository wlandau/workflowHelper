# library(testthat); library(workflowHelper);
context("plot")
source("utils.R")

test_that("Plotting with YAML \"plot: TRUE\" is as expected.", {
  files = c("code.R", "Makefile", "plot.pdf", "remake.yml", "workflow.R")
  msg = "[  PLOT ] plot.pdf   |  plot(poisson100) # ==> plot.pdf"
  expect_false(file.exists("plot.pdf"))
  sources = strings(code.R)
  datasets = commands(poisson100 = poisson_dataset(n = 100))

  outputs = list(
    commands(plot.pdf = ..plot.. <- plot(poisson100)),
    commands(plot.pdf = ..plot.. -> plot(poisson100)),
    commands(plot.pdf =  plot(poisson100) -> ..plot..),
    commands(plot.pdf =  plot(poisson100) <- ..plot..)
  )

  for(o in outputs){
    write_example_workflowHelper()
    plan_workflow(sources, datasets = datasets, output = o)
    out = system("make -j 2 2>&1", intern = T)
    expect_true(msg %in% out)
    expect_true(file.exists("plot.pdf"))
    cleanup(files)
  }
})