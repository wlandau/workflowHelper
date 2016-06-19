# library(testthat); library(workflowHelper);
context("knitr")
source("utils.R")

test_that("Functionality with knitr work as expected.", {
  msg = "[  KNIT ] report.md  |  knitr::knit(\"report.Rmd\", \"report.md\")"
  rmf1 = "report.md:\n    knitr:\n      options:\n        fig.height: 4.0\n    depends: poisson100\n"
  rmf2 = "report.md:\n    knitr: TRUE"
  sources = strings(code.R)
  datasets = commands(poisson100 = poisson_dataset(n = 100))

  outputs = list(
    commands(report.md = ..knitr.. <- list(fig.height =  4)),
    commands(report.md = ..knitr.. -> list(fig.height =  4)),
    commands(report.md =  list(fig.height =  4) <- ..knitr..),
    commands(report.md =  list(fig.height =  4) -> ..knitr..),
    commands(report.md = ..knitr..),
    commands(report.md = ..KNITR..),
    commands(report.md = ..report..),
    commands(report.md = ..rEpOrT..)
  )
  rmfs = c(rep(rmf1, 4), rep(rmf2, 4))

  for(i in 1:length(outputs)){
    write_example_workflowHelper()
    unlink("report.Rmd")
    write(readLines("test-knitr/report.Rmd"), "report.Rmd")
    plan_workflow(sources, datasets = datasets, output = unlist(outputs[i]))
    rmf = paste(readLines("remake.yml"), collapse = "\n")
    expect_true(grepl(rmfs[i], rmf))
    tmp = clean_example_workflowHelper(T)
  }
})