This folder contains an example of how to use [workflowOrganizer/README.md](https://github.com/wlandau/workflowOrganizer/blob/master/README.md). Run it as follows.

- Ensure that [R](https://www.r-project.org/), the [`parallelRemake`](https://github.com/wlandau/parallelRemake/) package, the [workflowOrganizer/README.md](https://github.com/wlandau/workflowOrganizer/blob/master/README.md) package, and [GNU make](https://www.gnu.org/software/make/) are installed.
- Run Makefile.R in an R session to generate the [Makefile](https://www.gnu.org/software/make/) and its constituent [`remake`](https://github.com/richfitz/remake)/[YAML](http://yaml.org/) files.
- Open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and point to the [current working directory](http://www.linfo.org/cd.html).
- Enter `make` into the command line to run the full workflow. To distribute the work over multiple parallel process, you can instead type `make -j <n>` where `<n>` is the number of processes.
- Optionally, inspect the final output files `coef.pdf` and `mse.csv`. Additionally, you can inspect the second-to-last files `coef.rds` and `mse.rds`.
- Optionally, clean up the output. Typing `make clean` removes the files produced by `make`. Similarly, `make clean_yaml` removes the [YAML](http://yaml.org/) files produced by `write_yaml`, `make clean_makefile` removes the [Makefile](https://www.gnu.org/software/make/), and `make clean_all` is equivalent to `make clean clean_yaml clean_makefile`.

# Details

Suppose I want to 

1. Generate some datasets.
2. Analyze each dataset with multiple statistical methods.
3. Compute summary statistics of each analysis of each dataset.
4. Aggregate the summary statistics together in convenient data frames.
5. Generate some tables and figures using those agregated summaries.

All the pieces of the workflow are in [workflowOrganizer/example/code.R]("https://github.com/wlandau/workflowOrganizer/blob/master/example/code.R"). 