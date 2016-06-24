# library(testthat); library(workflowHelper); library(remake)
context("knitr")
source("utils.R")
sources = strings(code.R)
datasets = commands(poisson100 = poisson_dataset(n = 100))
rmd = readLines("test-knitr/example-report.Rmd")

test_that("Knitr macros behave as expected.", {
  testwd("knitr-ok")
  msg = "[  KNIT ] report.md  |  knitr::knit(\"report.Rmd\", \"report.md\")"
  rmf1 = "report.md:\n    depends: datasets\n    knitr:\n      options:\n        fig.height: 4.0"
  rmf2 = "report.md:\n    depends: datasets\n    knitr: TRUE"

  reports = list(
    commands(report.md = list(fig.height =  4)),
    commands(report.md = list()),
    commands(report.md = TRUE)
  )
  rmfs = c(rmf1, rep(rmf2, 5))

  for(i in 1:length(reports)){
    write_example_workflowHelper()
    plan_workflow(sources, datasets = datasets, reports = unlist(reports[i]))
    rmf = paste(readLines("remake.yml"), collapse = "\n")
    expect_true(grepl(rmfs[i], rmf))
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

test_that("Knitr HTML targets work as expected", {
  testwd("knitr-html")
  write_example_workflowHelper()
  write(rmd, "report1.Rmd")
  write(rmd, "report2.Rmd")
  o = commands(
    report1.md = TRUE,
    report1.html = render("report1.md", quiet = TRUE),
    report1.pdf = write("report1.html", "report1.pdf"),
    report2.md = TRUE,
    report2.html = render("report2.md", quiet = TRUE),
    report2.pdf = write("report2.html", "report2.pdf")
  )
  plan_workflow(sources, packages = "rmarkdown", datasets = datasets, reports = o)
  expect_equal(readLines("remake.yml"), readLines("../test-knitr/two_compilations.yml"))
  remake::make(verbose = F)
  remake::make("clean", verbose = F)
  testrm()
})

