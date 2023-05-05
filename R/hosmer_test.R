#' Hosmer-Lemeshow Goodness of Fit (GOF) Test
#' @description
#' Hosmer-Lemeshow Goodness of Fit (GOF) Test is to check model quality of logistic regression models.
#' Note that this function has a unique way of dividing subgroups. See details.
#' @param model a \code{glm} -object with binomial-family.
#' @param g numeric, the number for how many subgroups the data should be divided into.
#' @details
#' The Hosmer-Lemeshow Goodness of Fit (GOF) Test is a method for obtaining statistics by dividing observed and expected values into several arbitrary subgroups.
#' The method of dividing the observed and expected values into subgroups is generally based on the quantile of the expected value, for example, by taking a decile of the expected value.
#' This method is used in the \code{hoslem.test()} function of the \code{resouceselection} package and the \code{performance_hosmer()} function of the \code{performance} package.
#' However, there are several variations on how to divide the subgroups, and this function uses a method in which the expected values are ordered from smallest to largest so that each subgroup has the same number of samples.
#' @references
#' David W. Hosmer, Stanley Lemesbow (1980). Goodness of fit tests for the multiple logistic regression model, Communications in Statistics - Theory and Methods, 9:10, 1043-1069, \doi{10.1080/03610928008827941}
#' @examples
#' data("Titanic")
#' df <- data.frame(Titanic)
#' df <- data.frame(Class = rep(df$Class, df$Freq),
#'                  Sex = rep(df$Sex, df$Freq),
#'                  Age = rep(df$Age, df$Freq),
#'                  Survived = rep(df$Survived, df$Freq))
#' model <- glm(Survived ~ . ,data = df, family = binomial())
#' hosmer_test(model)
#' @export

hosmer_test <- function(model, g = 10){

  df <- g - 2
  out <- cbind.data.frame(y = model$y,
                          fitted.values = model$fitted.values)
  out <- out[order(out$fitted.values, out$y, decreasing = FALSE),]
  step_by <- nrow(out) / g
  bin_step <- round(seq(step_by, nrow(out), step_by))
  n_stap <- c(bin_step[1], bin_step[-1] - bin_step[1:(length(bin_step) - 1)])
  out$bin <- unlist(mapply(function(x, y) rep(x, y),
                           1:length(n_stap),
                           n_stap,
                           SIMPLIFY = FALSE))
  obs <- stats::xtabs(cbind(1 - y, y) ~ bin, data = out)
  expect <- stats::xtabs(cbind(1 - fitted.values, fitted.values) ~ bin, data = out)
  chisq <- sum((obs - expect)^2 / expect)
  p.value <- 1 - stats::pchisq(chisq, df)

  names(chisq) <- "X-squared"
  names(df) <- "df"

  HL <- list(method = "Hosmer and Lemeshow goodness of fit (GOF) test",
             parameter = df,
             p.value = p.value,
             statistic = chisq,
             data.name = paste(deparse(model$call)),
             observed = obs,
             expected = expect)
  class(HL) <- "htest"
  HL
}
