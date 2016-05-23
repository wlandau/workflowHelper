With this package, you can

- deploy massive simulation studies with ease. 
- rerun updated parts of a reproducible workflow doing redundant computation.
- distribute your workflow over multiple parallel processes.

Check out the [example](https://github.com/wlandau/workflowOrganizer/tree/master/example).


# Installation

Ensure that [R](https://www.r-project.org/), the [`storr`](https://github.com/richfitz/storr) package, [`remake`](https://github.com/richfitz/remake) package, the [`parallelRemake`](https://github.com/wlandau/parallelRemake) package, and [GNU make](https://www.gnu.org/software/make/) are installed. Open an R session and run 

```
library(devtools)
install_github("wlandau/workflowOrganizer")
```

Alternatively, you can build the package from the source and install it by hand. First, ensure that [git](https://git-scm.com/) is installed. Next, open a [command line program](http://linuxcommand.org/) such as [Terminal](https://en.wikipedia.org/wiki/Terminal_%28OS_X%29) and enter the following commands.

```
git clone git@github.com:wlandau/workflowOrganizer.git
R CMD build workflowOrganizer
R CMD INSTALL ...
```

where `...` is replaced by the name of the tarball produced by `R CMD build`.



