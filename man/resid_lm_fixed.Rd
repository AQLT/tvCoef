% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fixed_coef.R
\name{resid_lm_fixed}
\alias{resid_lm_fixed}
\title{Extract data frame for lm_fixed_coeff}
\usage{
resid_lm_fixed(x, fixed_var)
}
\arguments{
\item{x}{\code{lm} model}

\item{fixed_var}{list of variables that don't vary through time according to \link{hansen_test}}
}
\value{
A new environment where the explained variable is named "fixed".
}
\description{
According to parameter \code{fixed_var}, computes a new explained variable, which is the explained variable minus the product between estimated coefficients and values of the fixed variables.
}
