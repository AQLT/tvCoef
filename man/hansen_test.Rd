% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_hansen.R
\name{hansen_test}
\alias{hansen_test}
\title{Hansen Test}
\usage{
hansen_test(x, var, sigma = FALSE)
}
\arguments{
\item{x}{\code{lm} object.}

\item{var}{variables used for the joint test. By default all the variable are used.}

\item{sigma}{\code{logical} indicating if the joint test should include the variance}
}
\description{
Performs Hansen test
}
\details{
Perform Hansen test, which indicates if the variance of a model, a global model and the coefficients of the variable within this model are likely to be unstable over time.

HO: the coefficient/model is stable over time.
}
\examples{
model_gdp <- lm(
formula = growth_gdp ~ bc_fr_m1 + diff_bc_fr_m1,
data = gdp
)
hansen_test(model_gdp)

}
\references{
Bruce E Hansen "Testing for parameter instability in linear models". Journal of policy Modeling (1992)
}
