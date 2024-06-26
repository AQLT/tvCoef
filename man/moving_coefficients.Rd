% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/test_hansen.R
\name{moving_coefficients}
\alias{moving_coefficients}
\alias{fixed_coefficients}
\title{Detect Fixed or Moving Coefficients}
\usage{
moving_coefficients(
  x,
  a = c(5, 1, 2.5, 7.5, 10, 20),
  sigma = FALSE,
  intercept = TRUE
)

fixed_coefficients(
  x,
  a = c(5, 1, 2.5, 7.5, 10, 20),
  sigma = FALSE,
  intercept = TRUE
)
}
\arguments{
\item{x}{\code{lm} object.}

\item{a}{level}

\item{sigma}{\code{logical} indicating if the joint test should include the variance}

\item{intercept}{boolean indicating if the intercept should be consider as a moving coefficient when at least one other variable is moving.}
}
\value{
\code{NULL} if no variable selected, otherwise the order of the variables.
}
\description{
Functions to test if any coefficient is fixed or moving according to the Hansen test (\code{\link[=hansen_test]{hansen_test()}})
}
