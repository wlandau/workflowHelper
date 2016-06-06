With this package, you can

- deploy massive simulation studies with minimal code. 
- update your reproducible workflow while avoiding redundant computation (thanks to [`remake`](https://github.com/richfitz/remake)).
- distribute your workflow over multiple parallel processes (see [`parallelRemake`](https://github.com/wlandau/parallelRemake)).

# Installation

Ensure that [R](https://www.r-project.org/) and [GNU make](https://www.gnu.org/software/make/) are installed, as well as the dependencies in the [`DESCRIPTION`](https://github.com/wlandau/workflowHelper/blob/master/DESCRIPTION). Open an R session and run 

```
library(devtools)
install_github("wlandau/workflowHelper")
```

Alternatively, you can build the package from the source and install it by hand. First, ensure that [git](https://git-scm.com/) is installed. Next, open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and enter the following commands.

```
git clone git@github.com:wlandau/workflowHelper.git
R CMD build workflowHelper
R CMD INSTALL ...
```

where `...` is replaced by the name of the tarball produced by `R CMD build`.


# Example 

You can run this example from start to finish with the `run_example_workflow` function. Alternatively, you can set up earlier stages with `write_example_workflow` or `setup_example_workflow` and then run the output files by hand. The details below.

Suppose I want to 

1. Generate some datasets.
2. Analyze each dataset with multiple statistical methods (`lm` and `glm`).
3. Compute summary statistics of each analysis of each dataset (model coefficients and mean squared error) and aggregate the summaries together.
4. Generate some tables and figures using those aggregated summaries.

I keep the functions to generate data, analyze data, etc. in `code.R`, and I have a sketch of the whole workflow in `workflow.R`. You can generate both these files with the `write_example_workflow` function. Typically, in your own workflows, you will write similar R scripts by hand.

## A walk through `workflow.R`

First, I list the R scripts with my code and the packages it depends on.

```{r}
library(workflowHelper)
sources = strings(code.R, MASS)
```

The `.r` and `.R` extensions distinguish packages from source files. Also, `strings` converts R expressions into character strings, so I could have simply written `sources = c("code.R", "MASS")`.

Next, I list the commands to generate the datasets.

```{r}
datasets = commands(
  poisson100 = poisson_dataset(n = 100),
  normal100 = normal_dataset(n = 100),
  normal1000 = normal_dataset(n = 1000)
)
```

Be sure to give a name to each command (for example, `poisson_dataset(n = 100)` has the name `poisson100`). The `command` function checks for names and returns a named character vector, so I could have simply written `datasets = c(poisson100 = "poisson_dataset(n = 100)", normal100 = "normal_dataset(n = 100)", normal1000 = "normal_dataset(n = 1000)")`. For 4 replicates of each kind of dataset, assign `datasets = reps(datasets, 4)`.

Similarly, I specify the commands to analyze each dataset.

```{r}
analyses = commands(
  lm = lm_analysis(..DATASET..), # Just apply `lm`
  glm = glm_analysis(..DATASET..) # Modify dataset, then apply `glm`
)
```

The `..DATASET..` wildcard stands for the current dataset being analyzed, which will be an object returned by `poisson_dataset` or `normal_dataset`. For 3 replicates per dataset of each kind of analysis, assign `analyses = reps(analyses, 3)`. The `reps` function works on any character vector of commands.

When I list the methods of summarizing analyses, there is an additional `..ANALYSIS..` wildcard that similarly stands for the appropriate object returned by `lm_analysis` or `glm_analysis`.

```{r}
summaries = commands(
  mse = mse_summary(..DATASET.., ..ANALYSIS..), # mean squared error
  coef = coef_summary(..ANALYSIS..) # model coefficients
)
```

Next, I specify how to generate output at the end.

```{r}
output = commands(
  mse.pdf = mse_plot(),
  coef.csv = coef_table()
)
```

Optionally, I can prepend some lines to the overarching [Makefile](https://www.gnu.org/software/make/) for the workflow. In this way, I can configure my workflow for a [Slurm](https://en.wikipedia.org/wiki/Slurm_Workload_Manager) or [PBS](https://en.wikipedia.org/wiki/Portable_Batch_System) cluster or simply add comments.

```{r}
begin = c("# This is my Makefile", "# Variables...")
```

The stages and elements of my workflow are now planned. To put them all together, I use `plan_workflow`, which calls `parallelRemake::write_makefile`.

```{r}
plan_workflow(sources, datasets, analyses, summaries, output, begin)
```

## Running the workflow

After running the `workflow.R` script above, I have a [Makefile](https://www.gnu.org/software/make/) in my current working directory. Using this master [Makefile](https://www.gnu.org/software/make/) and a [command line program](http://linuxcommand.org/), I can run or clean up the workflow. Here are some options.

- `make` runs the full workflow, only building results that are out of date or missing.
- `make -j <n>` is the same as above with the workflow distributed over `<n>` parallel processes. Similarly, you can append `-j <n>` to any of the commands below to activate parallelism.
- `make datasets` just makes the datasets.
- `make analyses` just runs the analyses of all the datasets after ensuring that the datasets are up to date.
- `make summaries` computes individual summaries of each analysis of each dataset.
- `make aggregates` aggregates the summaries together.
- `make output` makes the final output of the workflow after ensuring all the previous results are up to date.
- `make clean` removes the files generated by `make`. If some of your files are produced by side effects, `make clean` might not remove them. In that case, updates to dependencies may not trigger the desired rebuilds, so you should read the next section. 
- `make reset` runs `make clean` and then removes the [Makefile](https://www.gnu.org/software/make/) and all its constituent [YAML](http://yaml.org/) files.


## Access to intermediate objects

Intermediate objects such as datasets, analyses, and summaries are maintained in [remake](https://github.com/richfitz/remake)'s hidden [`storr`](https://github.com/richfitz/storr) cache. At any point in the workflow, you can reload them using `recallable` and `recall`. First, I check to see which objects I can reload.

```{r}
> recallable()
 [1] "coef"                "mse"                 "normal100"          
 [4] "normal100_glm"       "normal100_glm_coef"  "normal100_glm_mse"  
 [7] "normal100_lm"        "normal100_lm_coef"   "normal100_lm_mse"   
[10] "normal1000"          "normal1000_glm"      "normal1000_glm_coef"
[13] "normal1000_glm_mse"  "normal1000_lm"       "normal1000_lm_coef" 
[16] "normal1000_lm_mse"   "poisson100"          "poisson100_glm"     
[19] "poisson100_glm_coef" "poisson100_glm_mse"  "poisson100_lm"      
[22] "poisson100_lm_coef"  "poisson100_lm_mse"  
> 
```

Then if I want to load `mse`, the list of summaries generated by `mse_summary` in `code.R`, I simply use `recall`.

```{r}
> recall(mse)
$normal100_glm
[1] 1.874037

$normal100_lm
[1] 0.8740369

$normal1000_glm
[1] 2.033148

$normal1000_lm
[1] 1.033148

$poisson100_glm
[1] 6.038514

$poisson100_lm
[1] 5.038514

> 
```

This should help you go back and debug `mse_plot` in `code.R`, which takes `mse` as an argument.

