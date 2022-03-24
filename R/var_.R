#' Interval Estimation of Population Variance and Hypothesis Testing
#' @description
#' Compute an interval estimate of the population variance of x and a hypothesis test using the given population variance.
#' @param x a (non-empty) numeric vector of data values.
#' @param alternative a character string specifying the alternative hypothesis, must be one of "two.sided" (default), "greater" or "less". You can specify just the initial letter.
#' @param mu a number indicating the true value of the population variance.
#' @param conf.level confidence level of the interval.
#' @details
#' The sample variance of the estimate is the unbiased variance computed with \code{stats::var}. It also calculates the population variance assuming the given value is the population.
#' @export

var_ <- function(x,
                 alternative = c("two.sided", "less", "greater"),
                 mu = 0,
                 conf.level = 0.95){
  alternative <- match.arg(alternative)
  dname <- deparse(substitute(x))

  stopifnot(is.vector(x) || is.data.frame(x))

  if(is.data.frame(x)){
    if(length(x) != 1)
      stop("data frames must be only one column")
    x <- as.vector(as.matrix(x))
  }
  stopifnot(is.numeric(x))

  if(!missing(mu) && (length(mu) != 1 || is.na(mu)))
    stop("'mu' must be a single number")
  if(!missing(conf.level) &&
     (length(conf.level) != 1 || !is.finite(conf.level) ||
      conf.level < 0 || conf.level > 1))
    stop("'conf.level' must be a single number between 0 and 1")

  nx <- length(x)
  if(nx < 2)
    stop("data are essentially constant")
  df <- nx - 1

  estimate <- stats::var(x)
  ESTIMATE <- c(estimate, estimate * df / nx)
  statistic <- df * estimate / mu
  names(ESTIMATE) <- c("sample_variance", "population_variance")
  names(mu) <- "var"
  names(df) <- "df"
  names(statistic) <- "X-squared"

  if(alternative == "two.sided"){
    alpha <- (1 - conf.level) / 2
    cint <- c(df * estimate / stats::qchisq(1 - alpha, df),
              df * estimate / stats::qchisq(alpha, df))
    pval <- stats::pchisq(statistic, df, lower.tail = FALSE) * 2
    if(pval > 1)
      pval <- stats::pchisq(statistic, df, lower.tail = TRUE) * 2
  }else if(alternative == "less"){
    cint <- c(0, df * estimate / stats::qchisq(conf.level, df, lower.tail = FALSE))
    pval <- stats::pchisq(statistic, df, lower.tail = TRUE)
  }else if(alternative == "greater"){
    cint <- c(df * estimate / stats::qchisq(conf.level, df), Inf)
    pval <- stats::pchisq(statistic, df, lower.tail = FALSE)
  }
  attr(cint, "conf.level") <- conf.level

  rval <- list(statistic = statistic,
               parameter = df,
               conf.int = cint,
               estimate = ESTIMATE,
               null.value = mu,
               method = "Chi-squared test",
               p.value = pval,
               alternative = alternative,
               data.name = dname)
  class(rval) <- "htest"

  return(rval)
}
