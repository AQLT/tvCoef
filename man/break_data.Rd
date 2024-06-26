% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/piece_reg.R
\name{break_data}
\alias{break_data}
\title{Break data}
\usage{
break_data(x, break_dates, left = TRUE, names = NULL, ...)
}
\arguments{
\item{x}{a \code{ts} or \code{mts} object to split}

\item{break_dates}{the date(s) at which you want to divide the data}

\item{left}{\code{logical}. By default set to \code{TRUE}, i.e. the breakdate is the end date of each subcolumn}

\item{names}{optional vector containing the names of the variables used to build the splitted data.
By default the function try to guess the names from the \code{x} parameter.}

\item{...}{other unused arguments}
}
\value{
a \code{mts} containing as many times more data columns than breakdates
}
\description{
Splits a database according to one (or more) date
}
