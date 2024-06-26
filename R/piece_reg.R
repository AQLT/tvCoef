#' @importFrom stats as.formula coef coefficients deltat end fitted frequency is.mts lm na.omit resid residuals start time ts ts.union tsp window is.ts
#' @importFrom stats formula
#' @importFrom utils tail
NULL

#' Break data
#'
#' @description Splits a database according to one (or more) date
#'
#' @param x a `ts` or `mts` object to split
#' @param break_dates the date(s) at which you want to divide the data
#' @param left `logical`. By default set to `TRUE`, i.e. the breakdate is the end date of each subcolumn
#' @param names optional vector containing the names of the variables used to build the splitted data.
#' By default the function try to guess the names from the `x` parameter.
#'
#' @param ... other unused arguments
#'
#' @return a `mts` containing as many times more data columns than breakdates
#'
#' @export

break_data <- function(x, break_dates, left = TRUE, names = NULL, ...) {
  if (is.null(names)) {
    if (is.mts(x)) {
      name_x <- colnames(x)
    } else {
      name_x <- deparse(substitute(x))
    }
  } else {
    name_x <- names
  }

  range_time_x = tsp(x)
  break_dates = c(range_time_x[1] - deltat(x) * left,
                  break_dates,
                  range_time_x[2] + deltat(x) * !left)
  res <- do.call(ts.union, lapply(1:(length(break_dates) - 1), function(i) {
    window(x,
           start = (break_dates[i] + deltat(x) * left),
           end = (break_dates[i + 1] - deltat(x) * !left))
  }))
  res[is.na(res)] <- 0
  colnames(res) <- sprintf("%s_%s",
                           rep(name_x, length(break_dates) - 1),
                           rep(break_dates[-1], each = length(name_x))
  )
  res
}

#' Piecewise regression
#'
#' @description Computes one global linear regression, on splitted data
#'
#' @param x `lm` object. It is the global regression model
#' @param break_dates optional, to indicate the breakdates if they are known. By default set to `NULL`.
#' @param fixed_var fixed variables (not splitted using `break_dates`).
#' @param left `logical`. By default set to `TRUE`, i.e. the breakdate is the end date of each submodel
#' @param tvlm By default set to `FALSE`. Indicates which model will be run on each sub data. `FALSE` means a [lm] will be run.
#' @param bw bandwidth of the local regression (when `tvlm = TRUE`).
#' @param ... other arguments passed to [tvReg::tvLM()].
#'
#' @details Computes possible breakdates if not filled in. Uses function [break_data] and run a linear regression on the same splitted data.
#'
#' @return Returns an element of class `lm`
#'
#' @export

piece_reg <- function(x, break_dates = NULL, fixed_var = NULL, tvlm = FALSE, bw = NULL, left = TRUE, ...) {
  data <- get_data(x)
  intercept <- has_intercept(x)
  if (intercept) {
    data_ <- cbind(data[, 1], 1, data[, -1])
    colnames(data_) <- c("y", "(Intercept)", colnames(data)[-1])
    data <- data_
  } else {
    colnames(data) <- c("y", colnames(data)[-1])
  }
  formula <- "y ~ 0 + ."

  if (is.null(break_dates)) {
    break_dates <- strucchange::breakdates(strucchange::breakpoints(as.formula(formula), data = data))
  }
  if (all(is.na(break_dates))) {
    if (!tvlm) {
      return(x)
    } else {
      tv = tvReg::tvLM(formula = formula, data = data, bw = bw, ...)
      return(tv)
    }
  }
  if(is.null(fixed_var)) {
    data_break <- break_data(data[,-1], break_dates = break_dates, left = left, names = colnames(data)[-1])
    data2 <- cbind(data[,1], data_break)
    colnames(data2) <- c(colnames(data)[1], colnames(data_break))
    if(!tvlm) {
      piecereg = dynlm::dynlm(formula = as.formula(formula), data = data2)
    } else {
      piecereg = tvReg::tvLM(formula = as.formula(formula), data = data2, bw = bw, ...)
    }
  } else {
    data_x = data[,-1]
    data_break <- break_data(data_x[,- fixed_var], break_dates = break_dates, left = left, names = colnames(data)[-1][-fixed_var])
    data2 <- cbind(data[,1], data_x[,fixed_var], data_break)
    colnames(data2) <- c(colnames(data)[1], colnames(data_x)[fixed_var], colnames(data_break))
    # reorder column in the same order
    n_breaks <- length(break_dates)
    non_fixed_var <- seq_len(ncol(data_x))[-fixed_var]
    i_list <- as.list(seq_len(ncol(data_x)))
    for(i in seq_along(non_fixed_var)){
      i_list[[non_fixed_var[i]]] <- seq.int(i, length.out = n_breaks + 1, by = length(non_fixed_var)) +
        length(fixed_var)
    }

    for(i in seq_along(fixed_var)){
      i_list[[fixed_var[i]]] <- i
    }
    i_list <- unlist(i_list) + 1
    data2 <- data2[,c(1, i_list)]
    if(!tvlm) {
      piecereg = dynlm::dynlm(formula = as.formula(formula), data = data2)
    } else {
      piecereg = tvReg::tvLM(formula = as.formula(formula), data = data2, bw = bw, ...)
    }
  }
  res <- list(
    model = piecereg,
    start = start(data),
    end = end(data),
    frequency = frequency(data),
    breakdates = break_dates,
    left_breaks = left,
    tvlm = tvlm
  )
  class(res) <- "piece_reg"
  res
}


#' @export
print.piece_reg <- function(x, ...) {
  print(x$model, ...)
}

#' @export
summary.piece_reg <- function(object, ...) {
  summary(object$model, ...)
}
