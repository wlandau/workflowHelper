# Run the example

- Ensure that [R](https://www.r-project.org/) and [GNU make](https://www.gnu.org/software/make/) are installed, as well as the [`workflowHelper`](https://github.com/wlandau/workflowHelper) package and its [dependencies](https://github.com/wlandau/workflowHelper/blob/master/DESCRIPTION).
- Run `Makefile.R` in an R session to generate the [Makefile](https://www.gnu.org/software/make/) and its constituent [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) files.
- Open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html).
- Enter `make` into the command line to run the full workflow. To distribute the work over multiple parallel process, you can instead type `make -j <n>` where `<n>` is the number of processes.
- Optionally, inspect the final output files `coef.pdf` and `mse.csv`. Additionally, you can inspect the second-to-last files `coef.rds` and `mse.rds`.
- Optionally, clean up the output. Typing `make clean` removes all the files since the call to `Makefile.R`. There are also other intermediate targets for `clean` and the main workflow.

# Details

Suppose I want to 

1. Generate some datasets.
2. Analyze each dataset with multiple statistical methods (`lm` and `glm`).
3. Compute summary statistics of each analysis of each dataset (model coefficients and mean squared error) and aggregate the summaries together.
4. Generate some tables and figures using those agregated summaries.

All the pieces of this workflow are in [code.R]("https://github.com/wlandau/workflowHelper/blob/master/example/code.R"): i.e., functions for generating datasets, analyzing datsets, etc. All I need to do is put these pieces together.

I will need to tell `workflowHelper` where my code is stored and what packages it uses.

```{r}
library(workflowHelper)
sources = expr(code.R, MASS)
```

The package uses the `.r` and `.R` extensions to distinguish packages from source files. Above, `expr` converts R expressions into character strings, so `sources = expr("code.R", "MASS")` would be equivalent.

Next, I list the commands to generate the datasets I want,

```{r}
datasets = commands(
  poisson100 = poisson_dataset(n = 100),
  normal100 = normal_dataset(n = 100),
  normal1000 = normal_dataset(n = 1000)
)
```

where the `commands` function parses named expressions (equivalent to `datasets = c(poisson100 = "poisson_dataset(n = 100)",...)`). Some data are generated from Poisson distributions while others are generated from normal distributions. The RDS files on the left will be generated using the commands on the right. For example, the first command says to run `poisson_dataset(n = 100)` and save the object returned from the function as `CACHE/poisson100.rds`. All three of my datasets are generated similarly.

Next, I specify how to analyze each dataset

```{r}
analyses = commands(
  lm = lm_analysis(..DATASET..),
  glm = glm_analysis(..DATASET..)
)
```

These methods just run regressions with `lm` and `glm`, respectively. Each dataset will be analyzed with both methods, so there will be six analyses in all. Since I'm iterating over datasets, the `..DATASET..` placeholder is used in place of the dataset to be passed to the function. The analyses will be saved in files `CACHE/poisson100_lm.rds`, `CACHE/poisson100_glm.rds`, `CACHE/normal100_lm.rds`, etc.

Next, I specify the summary statistics I want for each analysis of each dataset. 

```{r}
summaries = commands(
  mse = mse_summary(..DATASET.., ..ANALYSIS..),
  coef = coef_summary(..ANALYSIS..)
)
```

Each analysis will be summarized with the mean squared error of model predictions (MSE) and the model coefficients from the `lm` and `glm` fits. Here, the `..ANALYSIS..` placeholder stands for the fitted model object returned by `lm_analysis` or `glm_analysis`. The individual summaries are saved in `CACHE/poisson100_lm_mse.rds`, `CACHE/poisson100_lm_coef.rds`, etc.

The names of the `summaries` vector are `mse` and `coef`, so RDS files `mse.rds` and `coef.rds` will be produced. (Unlike the previous RDS files, the aggregated summaries are not stored in the `CACHE` folder.) Each is a named list containing the given summary (MSE or coefficients) of each analysis of each dataset. The names of the lists in `mse.rds` and `coef.rds` are the relative paths to the RDS files containing the individual summaries.


Finally, I spedicify how to generate output.

```{r}
output = commands(
  mse.csv = mse_as_csv("mse.rds"),
  coef.pdf = plot_coef("coef.rds")
)
```

Unlike the previous commands, the names on the left stand for regular files with extensions, not RDS files with extensions omitted. `mse_as_csv` and `plot_coef` load the RDS files of summaries and generate `mse.csv` and `coef.pdf`, respectively.

The stages of my workflow are now planned. To put them all together, I use `plan_workflow`, which calls `parallelRemake::write_makefile`.

```{r}
plan_workflow(sources, datasets, analyses, summaries, output)
```

Now, there is a [Makefile](https://www.gnu.org/software/make/) in my current working directory. There are also several hidden [YAML](http://yaml.org/) files in the same directory, all of which are necessary to the [Makefile](https://www.gnu.org/software/make/). To actually run or manage the workflow, just open a [command line program](http://linuxcommand.org/) and enter one of the following.

- `make` runs the full workflow, only building targets that are out of date.
- `make -j <n>` is the same as above with the workflow distributed over `<n>` parallel processes. Similarly, you can append `-j <n>` to any of the commands below to activate parallelism.
- `make datasets` just makes the datasets.
- `make analyses` just runs the analyses of all the datasets after ensuring that the datasets are up to date.
- `make summaries` just makes the individual summary of each analysis of each dataset after ensuring that the datasets and analyses are up to date. However, the summaries are not aggregated. In this example, that means that `mse.rds` and `coef.rds` are not made.
- `make aggregates` makes the aggregates of the summaries (`mse.rds` and `coef.rds` in this example) after ensuring the datasets, analyses, and summaries are up to date.
- `make output` makes the final output of the workflow after ensuring all the previous results are up to date.
- `make clean` removes the files generated by `make`. If some of your files are produced by side effects, `make clean` might not remove them. In that case, use the `clean` argument of `plan_workflow` to add more shell commands to the `clean` rule. For example, 
```{r}
plan_workflow(sources, datasets, analyses, summaries, output, clean = c("rm -f output1.csv", "rm -f plot5.pdf"))
```
- `make reset` runs `make clean` and then removes the [Makefile](https://www.gnu.org/software/make/) and all its constituent [YAML](http://yaml.org/) files.