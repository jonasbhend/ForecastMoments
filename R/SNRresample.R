#' @rdname SNRresample
#' @aliases SNRgen
#'
#' @title Resample verification statistics
#'
#' @description Using parametric bootstrapping, resample a collection of verification
#' statistics on the forecasts and observations based on the characterization by
#' key measures (parameters of the signal-to-noise model) with \code{SNRresample}
#' and generate bootstrap samples with \code{SNRgen}.
#'
#' @param fcst \code{n x m} matrix of \code{n} forecasts with \code{m} ensemble
#'   members
#' @param obs vector of \code{n} verifying observations
#' @param fun One of function, list of functions, or character vector with names
#'   of verification functions to be used with
#'   \code{\link[easyVerification]{veriApply}}
#' @param nboot Number of bootstrap replicates to be drawn
#' @param mc.cores Number of cores to use for parallel computation
#' @param simplify logical or character string; attempt to reduce the result to
#'   a vector, matrix or higher dimensional array; see the simplify argument of
#'   \code{\link[base]{sapply}}.
#' @param ... additional arguments passed to verification functions.
#'
#' @examples
#' tm <- easyVerification::toymodel()
#' summary(SNRresample(tm$fcst, tm$obs, performanceMeasures))
#'
#' summary(SNRresample(tm$fcst, tm$obs,
#'                     list(function(fcst, obs) {
#'                              list(mean_x = mean(fcst), mean_y = mean(obs))
#'                              },
#'                          function(fcst, obs) SNRparam(performanceMeasures(fcst, obs)))))
#'
#' summary(SNRresample(tm$fcst, tm$obs, c("EnsCorr", "Ens2AFC", "FairCrpss"), strategy = 'crossval'))
#'
#' @import easyVerification pbapply parallel
#' @export
SNRresample <- function(fcst, obs, fun, nboot = 200, mc.cores = 1, simplify=TRUE, ...) {
  oldpb <- pbapply::pboptions()$type
  pbapply::pboptions(type = 'none')
  on.exit(pbapply::pboptions(type = oldpb))
  if (is.character(fun)){
    evalfun <- function(x) sapply(fun, veriApply, fcst=x$fcst, obs=x$obs, simplify=simplify, ...)
  } else if (is.list(fun)){
    evalfun <- function(x) sapply(fun, function(f) f(x$fcst, x$obs), simplify=simplify, ...)
  } else if (is.function(fun)){
    evalfun <- function(x) fun(x$fcst, x$obs, ...)
  }

  out <- parallel::mclapply(0:nboot, function(i){
    evalfun(SNRgen(i, fcst, obs))
  },
  mc.cores = mc.cores)
  if (! is.logical(simplify) || simplify){
    out <- sapply(out, unlist, simplify=simplify)
  }
  class(out) <- 'SNRsample'
  return(out)
}

#' @rdname SNRresample
#' @param i number of forecast-obs pair to generate, in case this is set to
#'   zero, the original forecasts and observations are returned
#' @export
SNRgen <- function(i, fcst, obs){
  if (i == 0) return(list(fcst = fcst, obs=obs))
  param <- SNRparam(performanceMeasures(fcst, obs))
  N <- nrow(fcst)
  nens <- ncol(fcst)
  with(as.list(param), {
    s <- rnorm(N, mean=0, sd=sqrt(sigmas))
    y <- muy + s + rnorm(N, mean=0, sd=sqrt(sigmae))
    x <- mux + beta * s + array(rnorm(N*nens, mean=0, sd = sqrt(sigman)), c(N, nens))
    list(fcst = x, obs=y)
  })
}
