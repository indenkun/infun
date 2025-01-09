#' ML Estimation of Multivariate Normal Data
#' @description
#' Finds the Maximum Likelihood (ML) Estimates of the mean vector and variance-covariance matrix for multivariate normal data with (potentially) missing values.
#'
#' If the solution does not converge within the \code{iterlim} range specified by the \code{mlest()} function of the \code{mvnmle} package,
#' this function calculates the solution by multiplying \code{iterlim} by 10 and recalculating until a solution is obtained.
#' To avoid an infinite loop, the number of calculations is limited to \code{max_iterlim}.
#' @inherit mvnmle::mlest return details references examples
#' @inheritParams mvnmle::mlest
#' @param max_iterlim Numeric. Upper limit of the number of iterations to avoid infinite loops.
#' @seealso \code{\link[stats]{nlm}} \code{\link[mvnmle]{mlest}}
#' @export
mlest2 <- function(data, max_iterlim = 10000, ...){
  if(!requireNamespace("mvnmle", quietly = TRUE)) stop("This function will not work unless the `{mvnmle}` package is installed")
  ans <- mvnmle::mlest(data = data, ...)
  iterlim <- ans$iterations
  while(ans$stop.code == 4 && iterlim < max_iterlim){
    iterlim <- iterlim * 10
    if(iterlim > max_iterlim) break
    ans <- mvnmle::mlest(data = data, iterlim = iterlim, ...)
  }
  ans
}
