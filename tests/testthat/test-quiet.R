# library(testthat); library(workflowHelper);
context("quiet")
source("utils.R")

test_that("Quiet workflow is possible.", {
  testwd("quiet-ok")
  write_example_workflowHelper()
  source("workflow.R")
  sources = strings(code.R)
  packages = strings(MASS)
  datasets = commands(
    poisson100 = poisson_dataset(n = 100),
    normal100 = normal_dataset(n = 100),
    normal1000 = normal_dataset(n = 1000) 
  )
  plan_workflow(sources, packages, datasets = datasets, remake_args = list(verbose = F))
  out = system("make -j 4", intern = T)
  expect_equal(sort(out), sort(readLines("../test-quiet/output.txt")))
  testrm()
})
