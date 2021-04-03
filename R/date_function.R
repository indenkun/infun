#' Date Related Functions
#' @description
#' \code{random.Date()} is a function that randomly creates a vector of dates at a specified sample size between a specified date and a date.
#'
#' \code{age.cal()} is a function that calculates the number of years (age by default), months, and days from a specified date to a specified date.
#' @param from starting date. Required.
#' @param to end date.Optional. Optional. Default is today (`sys.Date()`).
#' @param size a non-negative integer giving the number of items to choose.
#' @param replace should sampling be with replacement?
#' @param prob a vector of probability weights for obtaining the elements of the vector being sampled.
#' @param by increment of the sequence.
#'
#' @rdname Date.function
#' @return A vector of class "Date".
#'
#' @seealso
#' \code{\link[base]{Date}}, \code{\link[base]{seq.Date}}, \code{\link[base]{sample}}
#' @export

random.Date <- function(from, to = Sys.Date(), size, replace = FALSE, prob = NULL, by = "day"){
  if(length(from) != 1){
    warning("'from' must be of length 1")
    return(NA)
  }else if(length(to) != 1){
    warning("'to' must be of length 1")
    return(NA)
  }else if(length(size) != 1){
    warning("'size' must be of length 1")
    return(NA)
  }

  sample(seq(as.Date(from), as.Date(to), by = by), size = size, replace = replace, prob = prob)
}

#' @rdname Date.function
#' @export

age.cal <- function(from, to = Sys.Date(), by = "year"){
  if(length(to) != 1){
    warning("'to' must be of length 1")
    return(NA)
  }

  unname(sapply(from, function(x){length(seq(as.Date(x), as.Date(to), by = by)) - 1}))
}
