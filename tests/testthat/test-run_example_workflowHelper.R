# library(testthat); library(workflowHelper);
context("run_example_workflowHelper")
source("utils.R")

test_that("Example runs as expected", {
  initial_files = list.files()
  files = c("code.R", "coef.csv", "figure", "Makefile", "mse.pdf", "remake.yml", 
    "report.md", "report.Rmd", "workflow.R")
  out = run_example_workflowHelper(T)
  expect_true(all(files %in% list.files()))
  good_recallable = scan("test-run_example_workflowHelper/recallable.txt", 
    what = "character", quiet = T)
  expect_true(all(sort(recallable()) == sort(good_recallable)))
  for(item in c("coef", "mse")){
    x = recall(item)
    expect_true(is.list(x))
    expect_equal(length(x), 6)
    expect_equal(length(names(x)), 6)
    expect_equal(min(nchar(names(x))), 12)
    u = sapply(x, length)
    expect_true(all(u >= 1))
    expect_equal(length(unique(u)), 1)
    expect_true(all(is.finite(do.call(rbind, x))))
    expect_true(all(is.numeric(do.call(rbind, x))))
  }
  expect_true(file.exists(".remake"))
  expect_true(file.exists("report.md"))
  expect_true(length(readLines("report.md")) > 40)
  out = clean_example_workflowHelper(T)
  expect_false(file.exists(".remake"))
  expect_equal(list.files(), initial_files)
})
