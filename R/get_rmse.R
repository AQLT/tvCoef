
#' Get elements of rmse_prev
#'
#' @name get_rmse
#'
#' @param model result of [rmse_prev] fonction
#' @param date the date on which we want the tvlm coefficients
#' @param variable `integer`. The variable of which we want the coefficients at the given date
#' @param ... other unused parameters
#'
#' @details
#'
#' `get_lm_coeff` allows to get all coefficients of all linear regression prediction models
#'
#' `get_tvlm_coeff` allows to get all coefficients of the variable at a certain date of all local regression prediction models
#'
#' `get_tvlm_bw` allows to get the bandwidth of all local regression prediction models
#'
#' `get_rmse_bw_small` allows to get rmse of linear, local and piecewise regression prediction models, when the bandwidth of the prediction model is different from 20.
#'
#' `get_coeff_plot` plot `get_tvlm_coeff` of a certain variable at a certain date, `get_lm_coeff` of the same variable and the bandwidth of all prediction models, thanks to `get_tvlm_bw`. It also highlights when the bandwidth is equal to 20.
#'
#'
#' @rdname get_rmse
#' @export

get_lm_coef = function(model) {
  ts(matrix(unlist(lapply(model$forecast$prev_lm$model, coefficients)),
            ncol = length(coefficients(model$model$lm)),
            byrow = TRUE),
     start = model$forecast$prev_tvlm$end_dates[1],
     frequency = model$model$piece_lm$frequency,
     names = names(coefficients(model$model$lm))
  )
}


#' @rdname get_rmse
#' @export

get_tvlm_coef = function(model, date, variable) {
  tvlm_prev = model$forecast$prev_tvlm
  ts_coeff = sapply(seq_along(tvlm_prev$model), function(i) {
    ts(coefficients(tvlm_prev$model[[i]]),
       end = tvlm_prev$end_dates[[i]],
       frequency = tvlm_prev$frequency)
  })
  tvlm_variable = sapply(seq_along(ts_coeff), function(i) {
    window(ts_coeff[[i]][,variable], start = date, end = date, extend = TRUE)
  })
  tvlm_variable = ts(tvlm_variable,
                     start = model$forecast$prev_tvlm$end_dates[1],
                     frequency = model$forecast$prev_lm$frequency,
                     names = names(coefficients(model$model$lm))[variable])
  tvlm_variable
}

#' @rdname get_rmse
#' @export

get_tvlm_bw = function(model) {
  sapply(model$forecast$prev_tvlm$model, `[[`, "bw")
}

#' @rdname get_rmse
#' @export

get_rmse_bw_small = function(model, ...) {
  time_bw_s = time(get_lm_coef(model))[round(get_tvlm_bw(model), 1) != 20] + deltat(time(get_lm_coef(model)))
  resid_prev_lm_bws = model$forecast$prev_lm$residuals[time(model$forecast$prev_lm$residuals) %in% time_bw_s]
  resid_prev_piece_lm_bws = model$forecast$prev_piece_lm$residuals[time(model$forecast$prev_piece_lm$residuals) %in% time_bw_s]
  resid_prev_tvlm_bws = model$forecast$prev_tvlm$residuals[time(model$forecast$prev_tvlm$residuals) %in% time_bw_s]
  resid = list("lm" = resid_prev_lm_bws, "piece_lm" = resid_prev_piece_lm_bws, "tvlm" = resid_prev_tvlm_bws)
  sapply(resid, rmse)
}

## @rdname get_rmse
## @export

# get_coeff_plot = function(model, date, variable, titre = NULL) {
#   if (is.null(titre))
#     titre <- paste(colnames(get_lm_coef(model))[variable], "in", date)
#   data_plot <- data.frame(x = time(get_lm_coef(model)[,variable]),
#                           lm_coef = get_lm_coef(model)[,variable],
#                           tvlm_coef = get_tvlm_coef(model, date, variable),
#                           bw = get_tvlm_bw(model))
#   data_ribbon <- data.frame(x = data_plot$x[round(data_plot$bw, 1) == 20],
#                             breaks = cumsum(round(data_plot$bw, 1) != 20)[round(data_plot$bw, 1) == 20],
#                             ymin = min(data_plot[,c("lm_coef", "tvlm_coef")], na.rm = TRUE),
#                             ymax = max(data_plot[,c("lm_coef", "tvlm_coef")], na.rm = TRUE))
#   p1 <- ggplot2::ggplot(data_plot, ggplot2::aes(x = x))+
#     ggplot2::geom_ribbon(data = data_ribbon, ggplot2::aes(ymin = ymin, ymax = ymax, x = x, group = breaks), fill = "grey70", alpha = 0.2) +
#     ggplot2::geom_line(ggplot2::aes(y = tvlm_coef, colour = "TVLM")) +
#     ggplot2::geom_line(ggplot2::aes(y = lm_coef, colour = "LM")) +
#     ggplot2::labs(x = "", y = "Models", title = titre) +
#     ggplot2::scale_color_manual("", breaks = c("TVLM", "LM"),
#                                 values = c("red", "green"))
#   p2 <- ggplot2::ggplot(data_plot, aes(x = x))+
#     ggplot2::geom_line(aes(y = bw)) +
#     labs(x = "", y = "bw")
#   p1 <- p1 + ggplot2::theme_bw() +
#     ggplot2::theme(legend.position = "top",
#                    plot.title = element_text(hjust = 0.5))
#   p2 <- p2 + ggplot2::theme_bw() +
#     ggplot2::theme(legend.position = "top",
#                    plot.title = element_text(hjust = 0.5))
#   patchwork::wrap_plots(p1,p2, ncol = 1)
# }

