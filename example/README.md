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
sources = c("code.R", "MASS")
```

The package uses the `.r` and `.R` extensions to distinguish packages from source files. 

Next, I list the commands to generate the datasets I want.

```{r}
datasets = c(
  poisson100 = "poisson_dataset(n = 100)",
  normal100 = "normal_dataset(n = 100)",
  normal1000 = "normal_dataset(n = 1000)"
)
```

Some data are generated from Poisson distributions while others are generated from normal distributions. The RDS files on the left will be generated using the commands on the right. For example, the first command says to run `poisson_dataset(n = 100)` and save the object returned from the function as `CACHE/poisson10.rds`. All three of my datasets are generated similarly.

Next, I specify how to analyze each dataset

```{r}
analyses = c(
  lm = "lm_analysis(..DATASET..)",
  glm = "glm_analysis(..DATASET..)"
)
```

These methods just run regressions with `lm` and `glm`, respectively. Each dataset will be analyzed with both methods, so there will be six analyses in all. Since I'm iterating over datasets, the `..DATASET..` placeholder is used in place of the dataset to be passed to the function.

Next, I specify the summary statistics I want for each analysis of each dataset. 

```{r}
summaries = c(
  mse = "mse_summary(..DATASET.., ..ANALYSIS..)",
  coef = "coef_summary(..ANALYSIS..)"
)
```

Each analysis will be summarized with the mean squared error of model predictions (MSE) and the model coefficients from the `lm` and `glm` fits. Here, the `..ANALYSIS..` placeholder stands for the fitted model object returned by `lm_analysis` or `glm_analysis`. 

The names of the `summaries` vector are `mse` and `coef`, so RDS files `mse.rds` and `coef.rds` will be produced. (Unlike the previous RDS files, the aggregated summaries are not stored in the `CACHE` folder.) Each is a named list containing the given summary (MSE or coefficients) of each analysis of each dataset. The names of the lists in `mse.rds` and `coef.rds` are the relative paths to the RDS files containing the individual summaries.


Finally, I spedicify how to generate output.

```{r}
output = c(
  mse.csv = "mse_as_csv(\"mse.rds\")",
  coef.pdf = "plot_coef(\"coef.rds\")"
)
```

Unlike the previous commands, the names on the left stand for regular files with extensions, not RDS files with extensions omitted. `mse_as_csv` and `plot_coef` load the RDS files of summaries and generate `mse.csv` and `coef.pdf`, respectively.

The stages of my workflow are now planned. To put them all together, I use `plan_workflow`, which calls `parallelRemake::write_makefile`.

```{r}
plan_workflow(sources, datasets, analyses, summaries, output)
```

Now, there is a [Makefile](https://www.gnu.org/software/make/) in my current working directory. There are also several hidden [YAML](http://yaml.org/) files in the same directory, all of which are necessary to the [Makefile](https://www.gnu.org/software/make/). 

To actually run the workflow, just open a [command line program](http://linuxcommand.org/) and enter `make`. To distribute the workflow over multiple parallel processes, run `make -j <n>`, where <n> is the number of processes. This will generate all the datasets in parallel, then run all the analyses in parallel, etc. Optionally, I can clean up the output at the point. Typing `make clean` removes all the files since the call to `Makefile.R`. There are also other intermediate targets for `clean` and the main workflow.