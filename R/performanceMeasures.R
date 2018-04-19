#' @title performanceMeasures
#'
#' @description Performance measures of joint forecast observation distribution
#'
#' @details Six key performance measures of the joint probabilitiy distribution of
#' probabilistic forecasts (re-forecasts) and corresponding observations
#' are computed for diagnosis of forecast performance.
#'
#' @param fcst \code{n x m} matrix of \code{n} forecasts with \code{m} ensemble members
#' @param obs vector of \code{n} verifying observations
#'
#' @importFrom stats cov var
#' @export
performanceMeasures <- function(fcst,obs){
  stopifnot(is.matrix(fcst), is.vector(obs), nrow(fcst) == length(obs))

  R <- ncol(fcst)
  my <- mean(obs)
  mx <- mean(fcst)
  vy <- var(obs)
  crs <- cov(fcst)
  vx <- 1 / R * sum(diag(crs))
  c <- 1/(R*(R-1)) * sum(rowSums(crs) - diag(crs))
  sxy <- cov(obs, rowMeans(fcst))
  vxx <- mean(apply(fcst, 1, var))

  c(my = my,
    mx = mx,
    vy = vy,
    vx = vx,
    sxy = sxy,
    c = c,
    vxx = vxx)
}
