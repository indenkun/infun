#' Rounding to an Arbitrary Value
#'
#' @description
#' Outputs a sequence of numbers in which a given vector is close to a sequence of numbers in which an arbitrary value (positive) is specified and that value is the equal difference.
#' You can choose how to apply the close values by specifying \code{ceiling} or \code{floor} as the \code{type} argument to make it behave like rounding up or down.
#' If the value matches an arbitrary isoperimetric sequence, the value will be output as is.
#' \code{round_any_up} is a simplified version of \code{round_any}, which outputs the result with the argument of \code{type} fixed to \code{ceiling} and \code{origin} fixed to \code{0}.
#' \code{round_any_down} is a simplified version of \code{round_any}, where the \code{type} argument is fixed to \code{floor} and the \code{origin} is fixed to \code{0}.
#' \code{round_any_*} is faster than \code{round_any} in most cases, because the internal processing is done as a vector.
#' However, in rare cases, \code{round_any_*} may not be possible to obtain accurate values because of R's internal floating point arithmetic. \code{round_any} creates a sequence of numbers and compares them, so it gives accurate rounding results.
#'
#' @param x a numeric vector.
#' @param by Specify a positive value for the isoperimetric difference of the sequence of isoperimetric numbers for which you want to obtain an approximation.
#' @param type Specifies whether the value to be rounded is below or above the nearest value.
#' @param origin Specifies the first term of an identity sequence to be compared. The default value is 0.
#'
#' @rdname round_any
#' @export

round_any <- function(x, by, type = c("ceiling", "floor"), origin = 0){
  type <- match.arg(type)

  if(!is.vector(x) && !is.numeric(x)) stop("give 'x' a numeric vector.")
  if(length(by) != 1 && by < 0) stop("'by' should be given a positive value.")

  if(min(x) >= origin){
    comp.seq <- seq.default(origin, (ceiling(max(x)) + ceiling(by)), by = by)
  }else if(max(x) <= origin){
    comp.seq <- sort(seq.default(origin, (floor(min(x)) - ceiling(by)), by = by * -1))
  }else{
    comp.seq <- c(sort(seq.default(origin, (floor(min(x)) - ceiling(by)), by = by * -1)),
                  seq.default(origin, (ceiling(max(x)) + ceiling(by)), by = by)[seq.default(0, (ceiling(max(x)) + ceiling(by)), by = by) != origin])
  }

  if(type == "ceiling") unname(sapply(x, function(x) min(comp.seq[comp.seq >= x])))
  else if(type == "floor") unname(sapply(x, function(x) max(comp.seq[comp.seq <= x])))
}


#' @rdname round_any
#' @export

round_any_up = function(x, by){
  if(!is.vector(x) && !is.numeric(x)) stop("give 'x' a numeric vector.")
  if(length(by) != 1 && by < 0) stop("'by' should be given a positive value.")

  by * ceiling(x/by)
}

#' @rdname round_any
#' @export

round_any_down = function(x, by){
  if(!is.vector(x) && !is.numeric(x)) stop("give 'x' a numeric vector.")
  if(length(by) != 1 && by < 0) stop("'by' should be given a positive value.")

  by * floor(x/by)
}

