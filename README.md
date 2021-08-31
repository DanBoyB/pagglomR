# pagglomR

<!-- badges: start -->
[![R-CMD-check](https://github.com/TII-STP/pagglomR/workflows/R-CMD-check/badge.svg)](https://github.com/TII-STP/pagglomR/actions)
[![Codecov test coverage](https://codecov.io/gh/TII-STP/pagglomR/branch/master/graph/badge.svg)](https://codecov.io/gh/TII-STP/pagglomR?branch=master)
[![license](https://img.shields.io/badge/license-GPL--3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
<!-- badges: end -->

A package for calculating the agglomeration impacts of transport projects in 
Ireland.

This package is developed in the `R` programming language and requires an
installation of `R`. `R` can be downloaded from <https://cran.r-project.org/>. 
We would recommend the use of the 
[RStudio IDE](https://www.rstudio.com/products/rstudio/download/) when using R.


To install this package in `R` use the command 
`remotes::install_github("TII-STP/pagglomR")`. This will install the development
version. A stable version will be uploaded to CRAN in due course.

## Information

The `pagglomR` package has been developed for use on national roads projects in
line with the TII Project Appraisal Guidelines (PAG). It is a flexible tool 
that can also be used for public transport and multi-modal assessments.

For further information on the transport modelling analysis required to develop 
the necessary inputs for the `pagglomR`tool, refer to 
*PAG Unit 6.9 - Wider Impacts*.

The relevant economic parameters built into the `pagglomR` package are taken 
from the DPER *Public Spending Code (2019)*, the DoT 
*Common Appraisal Framework for Transport Projects and Programmes (2016)* and 
TII *PAG Unit 6.11 - National Parameter Values Sheet (2021)*.

## Key requirements

This package relies on outputs from a transport model in the form of demand and 
cost skims from "without scheme" / "Do Minimum" and "with scheme" / 
"Do Something" scenarios.



