#' Hosmer-Lemeshow Goodness of Fit Test
#' @description
#' Hosmer-Lemeshow Goodness of Fit Test is to check model quality of logistic regression models.
#' Note that this function has a unique way of dividing subgroups. See details.
#' @param model a \code{glm} -object with binomial-family.
#' @param g numeric, the number for how many subgroups the data should be divided into.
#' @param simple logical, If \code{TRUE} is selected, the expected values in decreasing order are evenly divided by the number of subgroups specified.
#'  if \code{FALSE}, identical expected values are placed in identical subgroups, and the number of subgroups is adjusted to make each subgroup as homogeneous as possible.
#'  See Detail for details.
#' @param force If \code{excat} is \code{TRUE}, then the total number of combinations is calculated to minimize the variance among all combinations and the combination with the lowest variance is selected among them. In other words, adjust the number of pieces in each group so that the numbers are as equal as possible.
#'  If \code{FALSE}, it pseudo-strives to minimize the variance of the number of pieces in each group, but prioritizes calculation speed and does not perform calculations from all combinations.
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
#' In this algorithm, the subgroup with the smallest number of expected values in the initial disjoint state is merged with its neighboring subgroups (with smaller or larger expected values) and the one with the smaller variance is adopted to create a new subgroup, and then the subgroup with the smallest number of expected values is merged with its neighboring expected value subgroups and the one with the smaller variance is adopted to create a new subgroup, and so on. The next subgroup with the lowest number of expected values is merged with the subgroup with the lowest variance, and the one with the lowest variance is adopted to create a new subgroup.
#' This procedure will result in a homogeneous number of subgroups as expected when the expected number of subgroups are relatively disparate, but will not create the expected number of subgroups when the expected number of subgroups are nearly homogeneous (e.g., only 1 or 2 of each).
#'
#' However, this algorithm may not minimize the variance.
#' For this reason, we can set \code{force} to \code{TRUE} with the value calculated by brute force. However, this would require a large amount of computation and may consume a large amount of memory and slow down the process until the result is obtained.
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
#'
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

hosmer_test <- function(model, g = 10, simple = FALSE, force = FALSE){
  if(!inherits(model, "glm"))
    stop("model must be an object of glm class.")
  if(stats::family(model)$family != "binomial" || stats::family(model)$link != "logit")
    stop("model must be link logit and family binomial.")
  if (g < 2L)
    stop("subgroups must be at least 2.")

  df <- g - 2
  out <- cbind.data.frame(y = model$y,
                          fitted.values = model$fitted.values)
  out <- out[order(out$fitted.values, out$y, decreasing = FALSE),]
  if(simple){
    step_by <- nrow(out) / g
    subgroup_step <- round(seq(step_by, nrow(out), step_by))
    n_step <- c(subgroup_step[1], subgroup_step[-1] - subgroup_step[1:(length(subgroup_step) - 1)])
    out$subgroup <- unlist(mapply(function(x, y) rep(x, y),
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
      out$subgroup <- unlist(mapply(function(x, y) rep(x, y),
                                    fitted.values_uni,
                                    fitted.values_uni_n,
                                    SIMPLIFY = FALSE))
      if(length(unique(round(out$subgroup, 3))) == length(unique(out$subgroup))) out$subgroup <- round(out$subgroup, 3)
    }else{
      fitted.values_uni_n <- sapply(fitted.values_uni, function(x) sum(out$fitted.values == x))

      if(force) n_step <- vec_n(fitted.values_uni_n, g = g)
      else n_step <- vec_g(fitted.values_uni_n, g = g)

      out$subgroup <- unlist(mapply(function(x, y) rep(x, y),
                                    1:length(n_step),
                                    n_step,
                                    SIMPLIFY = FALSE))

      subgroup_names <- sapply(1:length(n_step), function(x){
        subgroup_vec <- out$fitted.values[out$subgroup == x]
        subgroup_vec_min <- round(min(subgroup_vec), 3)
        subgroup_vec_max <- round(max(subgroup_vec), 3)
        if(subgroup_vec_min == subgroup_vec_max) subgroup_vec_min
        else paste(subgroup_vec_min, "-", subgroup_vec_max)
      })

      out$subgroup <- replace_match(out$subgroup, 1:length(n_step), subgroup_names)
    }
  }
  obs <- stats::xtabs(cbind(y0_obs = 1 - y, y1_obs = y) ~ subgroup, data = out)
  expect <- stats::xtabs(cbind(y0_expect = 1 - fitted.values, y1_expect = fitted.values) ~ subgroup, data = out)
  chisq <- sum((obs - expect)^2 / expect)
  p.value <- stats::pchisq(chisq, df, lower.tail = FALSE)

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
  if(g <= 3) stop("If g is less than 3, it cannot be calculated well.")

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

        ans_pre_var <- stats::var(ans_pre)
        ans_pos_var <- stats::var(ans_pos)

        if(ans_pre_var < ans_pos_var || is.na(ans_pos_var)) ans <- ans_pre
        else ans_ <- ans_pos
      }
    })
    ans <- unlist(unname(ans_list[which.min(lapply(ans_list, stats::var))]))
    ans_len <- length(ans)
  }
  ans
}

#'

vec_n <- function(x, g){
  if(g <= 3) stop("If g is less than 3, it cannot be calculated well.")

  vec_add <- function(x){
    lapply(1:(length(x) - 1), function(a){
      if(a == 1) c(x[1] + x[2], x[3:length(x)])
      else if(a + 2 == length(x)) c(x[1:(a - 1)], x[a] + x[a + 1], x[a + 2])
      else if(a + 1 == length(x)) c(x[1:(a - 1)], x[a] + x[a + 1])
      else if(a == 2) c(x[1], x[2] + x[3], x[4:length(x)])
      else c(x[1:(a - 1)], x[a] + x[a + 1], x[(a + 2):length(x)])
    })
  }

  ans <- list(x)
  while(length(ans[[1]]) > g){
    ans <- lapply(ans, vec_add)
    ans <- unique(purrr::list_flatten(ans))
  }

  ans_n <- sapply(ans, stats::var)
  if(length(ans_n) == 1) ans <- unlist(ans)
  else if(length(min(ans_n)) == 1) ans <- unlist(ans[which.min(ans_n)])
  else{
    ans <- ans[ans_n == min(ans_n)]
    ans_n <- sapply(ans, min)
    ans <- unlist(ans[which.max(ans_n)])
  }
  ans
}
