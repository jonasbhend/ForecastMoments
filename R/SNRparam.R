#' @title SNRparam
#'
#' @description Parameters of signal-to-noise model from population moments
#'
#' @details Convert the six key performance measures to parameters of the
#'   corresponding signal-to-noise model.
#'
#' @param x vector with 6 performance measures
#'
#' @export
SNRparam <- function(x){
  stopifnot(names(x) %in% c("my", "mx", "vy", "vx", "sxy", "c", "vxx"))

  with(as.list(x), {
    c(mux = mx,
      muy = my,
      beta = c / sxy,
      sigmas = sxy**2 / c,
      sigmae = vy - sxy**2 / c,
      sigman = vx - c,
      vxx = vxx)
  })
}
