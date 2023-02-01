% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ssm_lm.R
\name{ssm_lm_oos}
\alias{ssm_lm_oos}
\title{Out of sample prevision of state space model}
\usage{
ssm_lm_oos(
  model,
  trend = FALSE,
  var_intercept = 0,
  var_variables = 0,
  fixed_intercept = TRUE,
  fixed_variables = TRUE,
  ...
)
}
\arguments{
\item{model}{a \code{lm} or \code{dynlm} model}

\item{trend}{trend}

\item{var_intercept}{??}

\item{var_variables}{??}

\item{fixed_intercept}{\code{logical}}

\item{fixed_variables}{\code{logical}}
}
\value{
Returns all coefficients of all variables and the residual
}
\description{
Computes out of sample previsions of a given state space model. Unlike \link{ssm_lm} it can manage dummies.
}