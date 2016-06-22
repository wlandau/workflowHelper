# library(testthat); library(workflowHelper); library(remake)
context("knitr")
source("utils.R")
sources = strings(code.R)
datasets = commands(poisson100 = poisson_dataset(n = 100))
rmd = readLines("test-knitr/example-report.Rmd")

test_that("Knitr macros behave as expected.", {
  testdir_down("knitr-ok")
  msg = "[  KNIT ] report.md  |  knitr::knit(\"report.Rmd\", \"report.md\")"
  rmf1 = "report.md:\n    knitr:\n      options:\n        fig.height: 4.0\n    depends: datasets"
  rmf2 = "report.md:\n    knitr: TRUE"

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
    plan_workflow(sources, datasets = datasets, output = unlist(outputs[i]))
    rmf = paste(readLines("remake.yml"), collapse = "\n")
    expect_true(grepl(rmfs[i], rmf))
    tmp = clean_example_workflowHelper(T)
  }
  testdir_up()
})

test_that("Knitr md targets work as expected", {
  testdir_down("knitr-md")
  write_example_workflowHelper()
  write(rmd, "report1.Rmd")
  write(rmd, "report2.Rmd")
  o = commands(report1.md = ..knitr.., report2.md = ..report..)
  plan_workflow(sources, datasets = datasets, output = o)
  remake::make(verbose = F)
  remake::make("clean", verbose = F)
  expect_equal(readLines("remake.yml"), readLines("../test-knitr/two_reports.yml"))
  testdir_up()
})

test_that("Knitr HTML targets work as expected", {
  testdir_down("knitr-html")
  write_example_workflowHelper()
  write(rmd, "report1.Rmd")
  write(rmd, "report2.Rmd")
  o = commands(
    report1.md = ..knitr..,
    report1.html = render("report1.md", quiet = TRUE),
    report1.pdf = write("report1.html", "report1.pdf"),
    report2.md = ..knitr..,
    report2.html = render("report2.md", quiet = TRUE),
    report2.pdf = write("report2.html", "report2.pdf")
  )
  plan_workflow(sources, packages = "rmarkdown", datasets = datasets, output = o)
  remake::make(verbose = F)
  remake::make("clean", verbose = F)
  expect_equal(readLines("remake.yml"), readLines("../test-knitr/two_compilations.yml"))
  testdir_up()
})

