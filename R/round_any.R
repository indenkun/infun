#' Rounding to an Arbitrary Value
#'
#' @description
#' Outputs a sequence of numbers in which a given vector is close to a sequence of numbers in which an arbitrary value (positive) is specified and that value is the equal difference.
#' You can choose how to apply the close values by specifying \code{ceiling} or \code{floor} as the \code{type} argument to make it behave like rounding up or down.
#' If the value matches an arbitrary isoperimetric sequence, the value will be output as is.
#'
#' @param x a numeric vector.
#' @param by Specify a positive value for the isoperimetric difference of the sequence of isoperimetric numbers for which you want to obtain an approximation.
#' @param type Specifies whether the value to be rounded is below or above the nearest value.
#' @param origin Specifies the first term of an identity sequence to be compared. The default value is 0.
#'
#' @export

round_any <- function(x, by, type = c("ceiling", "floor"), origin = 0){
  type <- match.arg(type)

  if(!is.vector(x) && !is.numeric(x)) stop("give 'x' a numeric vector.")
  if(by < 0) stop("'by' should be given a positive value.")

  if(min(x) >= origin){
    comp.seq <- seq.default(origin, (ceiling(max(x)) + ceiling(by)), by = by)
  }else if(max(x) <= origin){
    comp.seq <- sort(seq.default(origin, (floor(min(x)) - ceiling(by)), by = by * -1))
  }else{
    comp.seq <- c(sort(seq.default(origin, (floor(min(x)) - ceiling(by)), by = by * -1)),
                  seq.default(origin, (ceiling(max(x)) + ceiling(by)), by = by)[seq.default(0, (ceiling(max(x)) + ceiling(by)), by = by) != origin])
  }

  if(type == "ceiling") sapply(x, function(x) min(comp.seq[comp.seq >= x]))
  else if(type == "floor") sapply(x, function(x) max(comp.seq[comp.seq <= x]))
}
