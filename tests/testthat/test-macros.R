# library(testthat); library(workflowHelper);
context("macros")
source("utils.R")

test_that("Dataset and analysis macros are not case sensitive.", {
  testdir_down("macros-case")
  for(i in 1:3){
    source(paste0("../test-macros/workflow", i, ".R"))
    f = paste0("remake", i, ".yml")
    l = readLines(f)
    for(p in c("dataset[^sS(]", "analysis[^(]"))
      expect_equal(grep(p, l, ignore.case = T), integer(0))
    unlink(f)
  }
  testdir_up()
})

test_that("Macros work as expected.", {
  for(x in c("dataset", "analysis")){
    expect_true(grepl(x, macro(x)))
    expect_false(grepl(macro(x), x))
    expect_true(grepl(macro(x), paste0("..", x, "..")))
    expect_false(grepl(macro(x), paste0("  ", x, "..")))
    expect_false(grepl(macro(x), paste0("idk", x, "  ")))
  }
})
