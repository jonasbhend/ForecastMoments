#' Summary of bootstrapped SNR samples
#'
#' Computes and prints a formatted summary of bootstrap replicates
#' generated with \code{\link{SNRresample}}.
#'
#' @param object object of class \code{SNRsample} returned by \code{\link{SNRresample}}
#' @param plev percentiles of the bootstrap distribution to be returned
#' @param ... additional parameters for consistency with generic
#' @importFrom stats quantile sd
#' @export
summary.SNRsample <- function(object, plev=c(0.025, 0.975), ...){
  if (is.list(object)){
    print("not implemented yet")
  } else {
    if (is.vector(object)) {
      object <- t(as.matrix(object))
    }
    out <- data.frame(orig = object[,1],
                       boot_mean = apply(object[,-1], 1, mean),
                       boot_sd = apply(object[,-1], 1, sd))
    out[paste0('boot_p',plev)] <- t(apply(object[,-1], 1, quantile, prob=plev))
  }
  out
}
