# library(testthat); library(workflowHelper);
context("suppress Makefile")
source("utils.R")

test_that("Makefile can be suppressed.", {
  sources = strings(code.R)
  packages = strings(MASS)
  datasets = commands(
    poisson100 = poisson_dataset(n = 100),
    normal100 = normal_dataset(n = 100),
    normal1000 = normal_dataset(n = 1000) 
  )
  plan_workflow(sources, packages, datasets = datasets, makefile = NULL)
  expect_true(file.exists("remake.yml"))
  expect_false(file.exists("Makefile"))
  cleanup(c("remake.yml", "Makefile"))
})
