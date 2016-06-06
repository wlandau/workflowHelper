library(testthat)
library(workflowHelper)

Sys.setenv("R_TESTS" = "")
test_check("workflowHelper")
