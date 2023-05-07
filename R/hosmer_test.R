#' Hosmer-Lemeshow Goodness of Fit Test
#' @description
#' Hosmer-Lemeshow Goodness of Fit Test is to check model quality of logistic regression models.
#' Note that this function has a unique way of dividing subgroups. See details.
#' @param model a \code{glm} -object with binomial-family.
#' @param g numeric, the number for how many subgroups the data should be divided into.
#' @param simple logical, If TRUE is selected, the expected values in decreasing order are evenly divided by the number of subgroups specified.
#'  if FALSE, identical expected values are placed in identical subgroups, and the number of subgroups is adjusted to make each subgroup as homogeneous as possible.
#'  See Detail for details.
#' @details
#' The Hosmer-Lemeshow Goodness of Fit Test is a method for obtaining statistics by dividing observed and expected values into several arbitrary subgroups.
#' The method of dividing the observed and expected values into subgroups is generally based on the quantile of the expected value, for example, by taking a decile of the expected value.
#' This method is used in the \code{hoslem.test()} function of the \code{resouceselection} package and the \code{performance_hosmer()} function of the \code{performance} package.
#' It has been suggested that it may be more accurate to divide subgroups by quantiles such as decile.
#'
#' However, there are several variations on how to divide the subgroups, and this function uses a method in which the expected values are ordered from smallest to largest so that each subgroup has the same number of samples as possible.
#'
#' If simple is TRUE, the process simply divides the expected values in decreasing order by the number of subgroups specified so that they are evenly distributed.
#'
#' If simple is FALSE, the same expected values are included in the same subgroup, and the calculation is performed with the number of subgroups adjusted so that the minimum number of values in a subgroup is maximized and the variance of the number of values in each group is minimized.
#' In other words, it strives to keep the same number of values in the subgroups as much as possible, while ensuring that the same expected values are in the same subgroups.
#'
#' @returns
#' A list with class "\code{htest}" containing the following components:
#'
#' \item{statistic}{the value of the chi-squared test statistic, \code{(sum((observed - expected)^2 / expected))}.}
#' \item{parameter}{the degrees of freedom of the approximate chi-squared distribution of the test statistic \code{(g - 2)}.}
#' \item{p.value}{the p-value for the test.}
#' \item{method}{a character string of test performed.}
#' \item{data.name}{expressions (objects) for which logistic regression analysis has been performed.}
#' \item{observed}{the observed frequencies in a \code{g-by-2} contingency table.}
#' \item{expected}{the expected frequencies in a \code{g-by-2} contingency table.}
#'
#' @references
#' David W. Hosmer, Stanley Lemesbow (1980). Goodness of fit tests for the multiple logistic regression model, Communications in Statistics - Theory and Methods, 9:10, 1043-1069, \doi{10.1080/03610928008827941}
#' HOSMER, D.W., HOSMER, T., LE CESSIE, S. and LEMESHOW, S. (1997), A COMPARISON OF GOODNESS-OF-FIT TESTS FOR THE LOGISTIC REGRESSION MODEL. Statist. Med., 16: 965-980. \doi{10.1002/(SICI)1097-0258(19970515)16:9<965::AID-SIM509>3.0.CO;2-O}
#'
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

hosmer_test <- function(model, g = 10, simple = FALSE){

  df <- g - 2
  out <- cbind.data.frame(y = model$y,
                          fitted.values = model$fitted.values)
  out <- out[order(out$fitted.values, out$y, decreasing = FALSE),]
  if(simple){
    step_by <- nrow(out) / g
    bin_step <- round(seq(step_by, nrow(out), step_by))
    n_step <- c(bin_step[1], bin_step[-1] - bin_step[1:(length(bin_step) - 1)])
    out$bin <- unlist(mapply(function(x, y) rep(x, y),
                             1:length(n_step),
                             n_step,
                             SIMPLIFY = FALSE))
  }else{
    fitted.values_uni <- unique(out$fitted.values)
    fitted.values_uni_len <- length(fitted.values_uni)
    if(fitted.values_uni_len < g)
      stop("Cannot be calculated because the unique value of expected value is less than the number of groups specified.")
    else if(fitted.values_uni_len == g){
      fitted.values_uni_n <- sapply(fitted.values_uni, function(x) sum(out$fitted.values == x))
      out$bin <- unlist(mapply(function(x, y) rep(x, y),
                               fitted.values_uni,
                               fitted.values_uni_n,
                               SIMPLIFY = FALSE))
    }else{
      fitted.values_uni_n <- sapply(fitted.values_uni, function(x) sum(out$fitted.values == x))
      n_step <- vec_g(fitted.values_uni_n, g = g)

      out$bin <- unlist(mapply(function(x, y) rep(x, y),
                               1:length(n_step),
                               n_step,
                               SIMPLIFY = FALSE))

      bin_names <- sapply(1:length(n_step), function(x){
        bin_vec <- out$fitted.values[out$bin == x]
        bin_vec_min <- round(min(bin_vec), 3)
        bin_vec_max <- round(max(bin_vec), 3)
        if(bin_vec_min == bin_vec_max) bin_vec_min
        else paste(bin_vec_min, "-", bin_vec_max)
      })

      out$bin <- replace_match(out$bin, 1:length(n_step), bin_names)
    }
  }
  obs <- stats::xtabs(cbind(1 - y, y) ~ bin, data = out)
  expect <- stats::xtabs(cbind(1 - fitted.values, fitted.values) ~ bin, data = out)
  chisq <- sum((obs - expect)^2 / expect)
  p.value <- 1 - stats::pchisq(chisq, df)

  names(chisq) <- "X-squared"
  names(df) <- "df"

  HL <- list(method = "Hosmer and Lemeshow goodness of fit test",
             parameter = df,
             p.value = p.value,
             statistic = chisq,
             data.name = paste(deparse(model$call)),
             observed = obs,
             expected = expect)
  class(HL) <- "htest"
  HL
}

#'

vec_g <- function(x, g){
  ans <- x
  ans_len <- length(ans)
  while (ans_len > g){
    ans_min <- which(ans == min(ans))
    ans_list <- lapply(ans_min, function(ans_min){
      if(ans_min == 1){
        ans_ <- c(ans[ans_min] + ans[ans_min + 1], ans[(ans_min + 2):ans_len])
      }else if(ans_min == ans_len){
        ans_ <- c(ans[1:(ans_min - 2)], ans[ans_min - 1] + ans[ans_min])
      }else{
        if(ans_min == 2){
          ans_pre <- c(ans[ans_min - 1] + ans[ans_min], ans[(ans_min + 1):ans_len])
        }else{
          ans_pre <- c(ans[1:(ans_min - 2)], ans[ans_min - 1] + ans[ans_min], ans[(ans_min + 1):ans_len])
        }

        if((ans_min + 2) == ans_len){
          ans_pos <- c(ans[1:(ans_min - 1)], ans[ans_min] + ans[ans_min + 1], ans[ans_len])
        }else if((ans_min + 1) == ans_len){
          ans_pos <- c(ans[1:(ans_min - 1)], ans[ans_min] + ans[ans_min + 1])
        }else{
          ans_pos <- c(ans[1:(ans_min - 1)], ans[ans_min] + ans[ans_min + 1], ans[(ans_min + 2):ans_len])

        }

        ans_pre_var <- var(ans_pre)
        ans_pos_var <- var(ans_pos)

        if(ans_pre_var < ans_pos_var || is.na(ans_pos_var)) ans <- ans_pre
        else ans_ <- ans_pos
      }
    })
    ans <- unlist(unname(ans_list[which.min(lapply(ans_list, var))]))
    ans_len <- length(ans)
  }
  ans
}
