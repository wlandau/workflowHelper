# library(testthat); library(workflowHelper); library(remake)
context("knitr")
source("utils.R")
sources = strings(code.R)
datasets = commands(poisson100 = poisson_dataset(n = 100))
rmd = readLines("test-knitr/example-report.Rmd")

test_that("Knitr macros behave as expected.", {
  testwd("knitr-ok")
  msg = "[  KNIT ] report.md  |  knitr::knit(\"report.Rmd\", \"report.md\")"

  reports = list(
    commands(report.md = "poisson100"),
    commands(report.md = c("poisson100")),
    commands(report.md = list("poisson100")),
    commands(report.md = c()),
    commands(report.md = list()),
    commands(report.md = TRUE)
  )

  for(i in 1:length(reports)){
    write_example_workflowHelper()
    plan_workflow(sources, datasets = datasets, reports = unlist(reports[i]))
    expect_equal(readLines("remake.yml"), readLines(paste0("../test-knitr/remake", i, ".yml")))
    tmp = clean_example_workflowHelper(T)
  }
  testrm()
})

test_that("Knitr md targets work as expected", {
  testwd("knitr-md")
  write_example_workflowHelper()
  write(rmd, "report1.Rmd")
  write(rmd, "report2.Rmd")
  o = commands(report1.md = TRUE, report2.md = TRUE)
  plan_workflow(sources, datasets = datasets, reports = o)
  expect_equal(readLines("remake.yml"), readLines("../test-knitr/two_reports.yml"))
  remake::make(verbose = F)
  remake::make("clean", verbose = F)
  testrm()
})
