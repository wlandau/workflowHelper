# library(testthat); library(workflowHelper);
context("run_example_workflowHelper")
source("utils.R")

test_that("Example runs as expected", {
  testwd("run_example_workflowHelper")
  initial_files = list.files()
  files = c("code.R", "coef.csv", "figure", "latex.Rnw", "Makefile", 
    "markdown.Rmd", "mse.pdf", "remake.yml", "workflow.R")
  out = run_example_workflowHelper(T)
  expect_true(all(files %in% list.files()))
  good_recallable = scan("../test-run_example_workflowHelper/recallable.txt", 
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
  for(f in c("latex.tex", "latex.pdf", "markdown.md", "markdown.html"))
    expect_true(file.exists(f))
  expect_true(file.exists(".remake"))
  expect_true(length(readLines("markdown.md")) > 40)
  out = clean_example_workflowHelper(T)
  expect_false(file.exists(".remake"))
  expect_equal(list.files(), initial_files)
  testrm()
})
