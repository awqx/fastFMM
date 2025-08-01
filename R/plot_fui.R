#' Default FUI plotting
#'
#' Take a fitted \code{fui} object produced by \code{fastFMM::fui()} and
#' plot the point estimates of fixed effects. When variance was calculated, the plot
#' function also returns 95\% pointwise and joint confidence intervals.
#'
#' @param fuiobj A object returned from the \code{fui} function
#' @param num_row An integer that specifies the number of rows the plots will be displayed on. Defaults to p/2, where p is the number of predictors.
#' @param xlab A string that specifies the x-axis title (i.e., for the functional domain). Defaults to ``Functional Domain''
#' @param title_names A vector of strings that has length equal to number of covariates (plus intercept if relevant). Allows one to change the titles of the plots. Defaults to NULL which uses the variable names in the dataframe for titles.
#' @param ylim A 2-dimensional vector that specifies limits of the y-axis in plots.
#' @param align_x A scalar: aligns the plot to a certain point on the functional domain and sets this as 0. This is particularly useful if the functional domain is time. Defaults to 0.
#' @param x_rescale A scalar: rescales the x-axis of plots which is especially useful if time is the functional domain and one wishes to, for example, account for the sampling rate. Defaults to 1.
#' @param y_val_lim A positive scalar that extends the y-axis by a factor for visual purposes. Defaults to $1.10$. Typically does not require adjustment.
#' @param y_scal_orig A positive scalar that determines how much to reduce the length of the y-axis on the bottom. Defaults to 0.05. Typically does not require adjustment.
#' @param return Logical, indicating whether to return the data frame with the coefficient estimates and 95\% confidence intervals (CIs). Defaults to \code{FALSE}.
#'
#' @return Plots of point estimates and CIs. If \code{return = TRUE}, also returns
#' a list where each element is a data frame with the coefficient estimates and 95\% confidence intervals (CIs).
#'
#' @author Gabriel Loewinger \email{gloewinger@@gmail.com}, Erjia Cui \email{ecui@@umn.edu}
#'
#' @references Cui, E., Leroux, A., Smirnova, E., Crainiceanu, C. (2022). Fast
#' Univariate Inference for Longitudinal Functional Models. \emph{Journal of
#' Computational and Graphical Statistics}, 31(1), 219-230.
#' @references Loewinger, G., Cui, E., Lovinger, D., Pereira, F. (2024). A
#' Statistical Framework for Analysis of Trial-Level Temporal Dynamics in
#' Fiber Photometry Experiments. \emph{eLife}, 95802.
#'
#'
#' @export
#'
#' @import ggplot2
#' @importFrom gridExtra grid.arrange
#'
#' @examples
#' library(refund)
#' set.seed(1)
#' DTI_use <- DTI[DTI$ID %in% sample(DTI$ID, 6),]
#' fit_dti <- fui(formula = cca ~ case + visit + sex + (1 | ID),
#'                data = DTI_use, family = "gaussian", var = TRUE)
#' plot_fui(fit_dti)

plot_fui <- function(fuiobj,
                     num_row = NULL,
                     xlab = "Functional Domain",
                     title_names = NULL,
                     ylim = NULL,
                     align_x = NULL,
                     x_rescale = 1,
                     y_val_lim = 1.1,
                     y_scal_orig = 0.05,
                     return = FALSE
                     ){

  num_var <- nrow(fuiobj$betaHat) ## number of variables to plot
  plot_list <- res_list <- vector(length = num_var, "list")
  if(is.null(num_row))  num_row <- ceiling(num_var/2)
  name = NULL

  align <- ifelse(is.null(align_x), 0, align_x*x_rescale)

  if(is.null(title_names))    title_names <- rownames(fuiobj$betaHat)
  if(nrow(fuiobj$betaHat) != length(title_names) )  title_names <- rownames(fuiobj$betaHat)
  names(res_list) <- rownames(fuiobj$betaHat)

  for(r in 1:num_var){

    if(is.null(fuiobj$betaHat_var)){
      beta.hat.plt <- data.frame(s = fuiobj$argvals,
                                 beta = fuiobj$betaHat[r,])
      plot_list[[r]] <- ggplot() +
        theme_classic() +
        theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
        geom_line(aes(x = s / x_rescale - align/x_rescale - 1/x_rescale, y = beta, color = "Estimate"),
                  data = beta.hat.plt, alpha = 1, linewidth = 1) +
        geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
        scale_colour_manual(name="", values=c("Estimate"="black")) +
        labs(x = xlab, y = bquote(paste(beta[.(r-1)], "(s)")),
             title = title_names[r]) +
        theme(legend.position = "none")

    }else{

      beta.hat.plt <- data.frame(s = fuiobj$argvals,
                                 beta = fuiobj$betaHat[r,],
                                 lower = fuiobj$betaHat[r,] - 2*sqrt(diag(fuiobj$betaHat_var[,,r])),
                                 upper = fuiobj$betaHat[r,] + 2*sqrt(diag(fuiobj$betaHat_var[,,r])),
                                 lower.joint = fuiobj$betaHat[r,] - fuiobj$qn[r]*sqrt(diag(fuiobj$betaHat_var[,,r])),
                                 upper.joint = fuiobj$betaHat[r,] + fuiobj$qn[r]*sqrt(diag(fuiobj$betaHat_var[,,r])))

      plot_list[[r]] <- ggplot() +
        theme_classic() +
        theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
        geom_ribbon(aes(x = s / x_rescale - align/x_rescale - 1/x_rescale, ymax = upper.joint, ymin = lower.joint),
                    data = beta.hat.plt, fill = "gray20", alpha = 0.2) +
        geom_ribbon(aes(x = s / x_rescale - align/x_rescale - 1/x_rescale, ymax = upper, ymin = lower),
                    data = beta.hat.plt, fill = "gray10", alpha = 0.4) +
        geom_line(aes(x = s / x_rescale - align/x_rescale - 1/x_rescale, y = beta, color = "Estimate"),
                  data = beta.hat.plt, alpha = 1, linewidth = 1) +
        scale_colour_manual(name="", values=c("Estimate"="black")) +
        labs(x = xlab, y = bquote(paste(beta[.(r-1)], "(s)")),
             title = title_names[r]) +
        theme(legend.position = "none")

    }

    # make x and y intercepts
    if(!is.null(ylim)){
      plot_list[[r]] <- plot_list[[r]] + coord_cartesian(ylim = ylim)
      ylimit <- ylim
    }else{
      if(is.null(fuiobj$betaHat_var)){
        ylimit <- c(min(beta.hat.plt$beta), max(beta.hat.plt$beta))
        y_adjust <- y_scal_orig * (max(beta.hat.plt$beta) - min(beta.hat.plt$beta))
      }else{
        ylimit <- c(min(beta.hat.plt$lower.joint), max(beta.hat.plt$upper.joint)) #layer_scales(plot_list[[r]])$y$range$range
        y_adjust <- y_scal_orig * (max(beta.hat.plt$upper.joint) - min(beta.hat.plt$lower.joint)) #layer_scales(plot_list[[r]])$y$range$range
      }
      ylimit[1] <- ylimit[1] - y_adjust # just scale bottom because top is scaled below
    }

    xlim <- layer_scales(plot_list[[r]])$x$range$range

    x_range <- diff(xlim) * 0.1
    y_range <- diff(ylimit) * 0.1
    y_range_up <- diff(ylimit) * 0.02

    # extend upper limit
    ylimit.max <- max(ylimit) # find largest
    if(ylimit.max < 0)  y_val_lim <- 1 / y_val_lim # if negative, need to adjust rescaling factor
    y_val_lim_vec <- c(1, y_val_lim)
    y_top <- (0.975) * diff(ylimit*y_val_lim_vec) + ylimit[1]*y_val_lim_vec[1]
    plot_list[[r]] <- plot_list[[r]] + coord_cartesian(ylim = ylimit*y_val_lim_vec,
                      xlim = xlim)

    if(!is.null(align_x)){

      plot_list[[r]] <- plot_list[[r]] +
                          geom_segment(aes_string(y=ylimit[1] - y_range, yend=y_top,
                          x=0,xend=0), inherit.aes = TRUE, # don't extend up
                          color = "black", lwd=0.5, alpha = 0.75, linetype = "dashed")

    }

    if(!is.null(fuiobj$betaHat_var)){
      if(max(beta.hat.plt$upper.joint) > 0 & min(beta.hat.plt$lower.joint) < 0){
        plot_list[[r]] <- plot_list[[r]] +
          geom_segment(aes_string(x=xlim[1] - x_range, xend=xlim[2] + x_range,
                                  y=0,yend=0), inherit.aes = TRUE,
                       color = "black", lwd=0.5, alpha = 0.75, linetype = "dashed")
      }
      colnames(beta.hat.plt) <- c("s", "beta.hat", "CI.lower.pointwise", "CI.upper.pointwise", "CI.lower.joint", "CI.upper.joint")
    }else{
      colnames(beta.hat.plt) <- c("s", "beta.hat")
    }

    res_list[[r]] <- beta.hat.plt # save data frame associated with rth fixed effect

  }

  plot_return <- do.call("grid.arrange", c(plot_list, nrow = num_row)) # plot
  plot_return # show plots

  if(return == TRUE){
    res_list$plot <- plot_return # save to returned object
    return(res_list)
  }else{
    return(plot_return)
  }

}


