With this package, you can

- deploy massive simulation studies with ease. 
- rerun updated parts of a reproducible workflow while avoiding redundant computation.
- distribute your workflow over multiple parallel processes.

Check out the [example](https://github.com/wlandau/workflowHelper/tree/master/example).


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



