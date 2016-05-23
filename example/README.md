# Run the example

- Ensure that [R](https://www.r-project.org/), the [`parallelRemake`](https://github.com/wlandau/parallelRemake/) package, the [workflowHelper/README.md](https://github.com/wlandau/workflowHelper/blob/master/README.md) package, and [GNU make](https://www.gnu.org/software/make/) are installed.
- Run Makefile.R in an R session to generate the [Makefile](https://www.gnu.org/software/make/) and its constituent [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) files.
- Open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html).
- Enter `make` into the command line to run the full workflow. To distribute the work over multiple parallel process, you can instead type `make -j <n>` where `<n>` is the number of processes.
- Optionally, inspect the final output files `coef.pdf` and `mse.csv`. Additionally, you can inspect the second-to-last files `coef.rds` and `mse.rds`.
- Optionally, clean up the output. Typing `make clean` removes the files produced by `make`. Similarly, `make clean_yaml` removes the [YAML](http://yaml.org/) files produced by `write_yaml`, `make clean_makefile` removes the [Makefile](https://www.gnu.org/software/make/), and `make clean_all` is equivalent to `make clean clean_yaml clean_makefile`.

# Details

Suppose I want to 

1. Generate some datasets.
2. Analyze each dataset with multiple statistical methods (`lm` and `glm`).
3. Compute summary statistics of each analysis of each dataset (model coefficients and mean squared error).
4. Aggregate the summary statistics together in convenient data frames.
5. Generate some tables and figures using those agregated summaries.

All the pieces of this workflow are in [code.R]("https://github.com/wlandau/workflowHelper/blob/master/example/code.R"): i.e., functions for generating datasets, analyzing datsets, etc. All I need to do is put these pieces together.

I will need to tell `workflowHelper` where my code is stored and what packages it uses.

```{r}
sources = c("code.R", "MASS")
```

The package uses the `.r` and `.R` extensions to distinguish packages from source files. I can also specify the external packages that my code relies on. In this case, there are none.

```{r}
packages = NULL
```

Next, I list the commands to generate the datasets I want.

```{r}
datasets = c(
  poisson100 = "poisson_dataset(__SAVE__, n = 100)",
  normal100 = "normal_dataset(__SAVE__, n = 100)",
  normal1000 = "normal_dataset(__SAVE__, n = 1000)"
)
```

Some data are generated from Poisson distributions while others are generated from normal distributions. The RDS files on the left will be generated using the commands on the right. For example, the first command says to run `poisson_dataset("poisson10.rds", n = 100)` and save the result as `poisson10.rds`. All three of my datasets are generated similarly. `__SAVE__` is a placeholder for the file to save in the given command, and its counterparts are returned by the `placeholders` function. You will always be able to use the `__SAVE__` placeholder.

Next, I specify how to analyze each dataset

```{r}
analyses = c(
  lm = "lm_analysis(__SAVE__, __DATASET__)",
  glm = "glm_analysis(__SAVE__, __DATASET__)"
)
```

These methods just run regressions with `lm` and `glm`, respectively. Each dataset will be analyzed with both methods, so there will be six analyses in all. Since I'm iterating over datasets, the `__DATASET__` placeholder just stands for the RDS file containing my data (for example, `poisson.rds`). Only the `__SAVE__` and `__DATASET__` placeholders are valid here.

Next, I specify the summary statistics I want for each analysis of each dataset. 

```{r}
summaries = c(
  mse = "mse_summary(__SAVE__, __DATASET__, __ANALYSIS__)",
  coef = "coef_summary(__SAVE__, __ANALYSIS__)"
)
```

Each analysis will be summarized with the mean squared error of model predictions (MSE) and the model coefficients from the `lm` and `glm` fits. Here, the `__ANALYSIS__` placeholder stands for the RDS file containing the output of `lm` or `glm`, and it is specific to both the method of analysis and dataset analyzed. You may use the `__SAVE__`, `__DATASET__`, or `__ANALYSIS__` placeholders.

With 3 datasets, 2 methods of analysis, and 2 types of summary statistics, our summary statistics are spread over 12 different RDS files. To aggregate them back together, I issue the following.


```{r}
aggregates = c(
  mse = "aggregate_mse(__SAVE__, __SUMMARIES__)",
  coef = "aggregate_coef(__SAVE__, __SUMMARIES__)"
)
```

This ensures that there will be a data frame `mse.rds` of mean squared errors and another data frame `coef.rds` of model coefficients. Only the `__SAVE__` and `__SUMMARIES__` placeholders are valid here. Finally, I plan to generate the summaries.

```{r}
output = c(
  mse.csv = "mse_as_csv(__SAVE__)",
  coef.pdf = "plot_coef()"
)
```

This will convert `mse.rds` to `mse.csv` and plot the model coefficients of `coef.rds` in `coef.pdf`. Only the `__SAVE__` placeholder is valid here.

The stages of my workflow are now planned. To put them all together, I use `plan_workflow`, which calls `parallelRemake::write_makefile`.

```{r}
plan_workflow(sources, packages = NULL, datasets = datasets, analyses = analyses, 
  summaries = summaries, aggregates = aggregates, output = output)
```

Now, there is a [Makefile](https://www.gnu.org/software/make/) in my current working directory. There are also a bunch of  [YAML](http://yaml.org/) files, all of which are necessary to the [Makefile](https://www.gnu.org/software/make/). 

To actually run the workflow, just open a [command line program](http://linuxcommand.org/) and enter `make`. To distribute the workflow over multiple parallel processes, run `make -j <n>`, where <n> is the number of processes. This will generate all the datasets in parallel, then run all the analyses in parallel, etc.