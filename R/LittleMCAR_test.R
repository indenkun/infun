#' Little's missing completely at random (MCAR) test
#' @description
#' Use Little's (1988) test statistic to assess if data is missing completely at random (MCAR). The null hypothesis in this test is that the data is MCAR, and the test statistic is a chi-squared value.
#' In the \code{mlest()} function of the \code{mvnmle} package, the correct statistics could not be calculated because the solution of ML estimation may not converge with the default value.
#' Using a modified version of the \code{mlest2()} function, an algorithm is used to perform ML estimation until the solution converges.
#' @param data A data frame
#' @inheritDotParams mlest2
#'
#' @returns
#' A list with class \code{"htest"} containing the following components:
#' \item{statistic}{Chi-square value.}
#' \item{parameter}{Degrees of freedom used for chi-square.}
#' \item{p.value}{the p-value for the test.}
#' \item{method}{a character string indicating the type of test performed.}
#' \item{data.name}{a character string giving the name of the data.}
#' \item{missing.patterns}{Number of missing data patterns.}
#' \item{amount.missing}{Amount and percent of mssing data.}
#' \item{data}{The data, organized my missing data patterns.}
#' \item{stop.code}{The stop code returned by \code{\link[stats]{nlm}}.}
#' \item{iterations}{The number of iterations used by \code{\link[stats]{nlm}}.}
#'
#' @note
#' Code is adapted from \code{mcar_test} in \code{naniar} package.
#'
#' @seealso
#' \code{\link[infun]{mlest2}}
#'
#' @details
#' If \code{stop.code} is \code{4}, the solution of maximum likelihood estimation has not converged at the upper limit of the number of calculations set by \code{max_iterlim};
#'  change \code{max_iterlim} and recalculate with an increased upper limit.
#'
#' @examples
#' LittleMCAR_test(airquality)
#'
#' @export

LittleMCAR_test <- function(data, ...){
  if(!requireNamespace("mvnmle", quietly = TRUE)) stop("This function will not work unless the `{mvnmle}` package is installed")

  if (!(is.matrix(data) | is.data.frame(data)))
    stop("Data should be a dataframe")

  dname <- deparse(substitute(data))

  n.var <- ncol(data)
  n <- nrow(data)
  var.names <- colnames(data)

  # Number of missing data for each variable
  r <- 1 * is.na(data)
  nmis <- as.integer(apply(data, 2, sum))

  # Add pattern as column to original data
  mdp <- (r %*% (2^((1:n.var - 1)))) + 1
  x.mp <- data.frame(cbind(data, mdp))
  colnames(x.mp) <- c(var.names, "MisPat")

  # Number of unique missing data patterns
  n.mis.pat<-length(unique(x.mp$MisPat))

  p <- n.mis.pat-1

  # Maximum likelihood estimation
  ML_estimate <- suppressWarnings(mlest2(data = data, ...))
  # ML estimate of grand mean (assumes Normal dist)
  gmean <- ML_estimate$muhat
  # ML estimate of grand covariance (assumes Normal dist)
  gcov <- ML_estimate$sigmahat
  colnames(gcov) <- rownames(gcov) <- colnames(data)

  #recode MisPat variable to go from 1 through n.mis.pat
  x.mp$MisPat2 <- rep(NA,n)
  for (i in 1:n.mis.pat){
    x.mp$MisPat2[x.mp$MisPat == sort(unique(x.mp$MisPat), partial = (i))[i]] <- i
  }
  x.mp$MisPat <- x.mp$MisPat2
  x.mp<-x.mp[, -which(names(x.mp) %in% "MisPat2")]

  #make list of datasets for each pattern of missing data
  datasets <- list()
  for (i in 1:n.mis.pat){
    datasets[[paste("DataSet",i,sep="")]] <- x.mp[which(x.mp$MisPat == i), 1:n.var]
  }

  #degrees of freedom
  kj <- 0
  for(i in 1:n.mis.pat){
    no.na <- as.matrix(1 * !is.na(colSums(datasets[[i]])))
    kj <- kj+colSums(no.na)
  }
  df <- kj -n.var

  #Little's chi-square
  d2 <- 0
  # cat("this could take a while")
  for(i in 1:n.mis.pat){
    mean <- (colMeans(datasets[[i]]) - gmean)
    mean <- mean[!is.na(mean)]
    keep <- 1 * !is.na(colSums(datasets[[i]]))
    keep <- keep[which(keep[1:n.var] != 0)]
    cov <- gcov
    cov <- cov[which(rownames(cov) %in% names(keep)) , which(colnames(cov) %in% names(keep))]
    d2 <- as.numeric(d2 + (sum(x.mp$MisPat == i) * (t(mean) %*% solve(cov) %*% mean)))
  }

  # p-value for chi-square
  p.value <- 1 - stats::pchisq(d2,df)

  #descriptives of missing data
  amount.missing <- matrix(nmis, 1, length(nmis))
  percent.missing <- amount.missing/n
  amount.missing <- rbind(amount.missing,percent.missing)
  colnames(amount.missing) <- var.names
  rownames(amount.missing) <- c("Number Missing", "Percent Missing")

  names(d2) <- "X-squared"
  names(df) <- "df"
  rval <- list(method = "Little's missing completely at random (MCAR) test",
               alternative = "the data is not Missing Completely at Random (MCAR)",
               statistic = d2,
               parameter = df,
               data.name = dname,
               p.value = p.value,
               missing.patterns = n.mis.pat,
               amount.missing = amount.missing,
               data = datasets,
               stop.code = ML_estimate$stop.code,
               iterations	= ML_estimate$iteration)

  if(rval$stop.code == 4){
    warning("The solution to maximum likelihood estimation of the multivariate normal distribution may not have converged.\n Adjust the values of arguments such as `iterlim` and so on.")
  }

  class(rval) <- "htest"

  rval

}
