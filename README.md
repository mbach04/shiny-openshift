# Rahti Shiny Source to Image builder

The Shiny application under `/application` in the application source is copied
to Shiny server root.

Packages listed--separated by newline--in file `/PACKAGES` are passed to
`install2.r -e` as arguments.

The builder image comes with the following R packages pre-installed:

* shinydashboard 
* DBI
* RPostgreSQL
* jsonlite
* dplyr
* magrittr
* dbplyr
* stringr
* tidyr
* DT
* ggplot2
* shinyjs
* scales
* plotly
* shinyBS
* lubridate
* shinyWidgets
* causaleffect

## Discussion

* Sometimes builds can be demanding due to R packages often requiring
  compilation of c/c++/fortran sources. 

## Using with `oc`

Assuming the S2I Images is placed in ImageStream `s2i-rshiny:latest`, the
application image is built via

```bash
$ oc new-build s2i-rshiny~<source location> --strategy=source --name=<name>
```
