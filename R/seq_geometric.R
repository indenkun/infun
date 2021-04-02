#' Generate Geometric Sequence
#'
#' @description
#' Function to generate a sequence of equal ratios, also known as a geometric sequence.
#' Geometric sequence, also known as a Geometric progression, is a sequence of non-zero numbers where each term after the first is found by multiplying the previous one by a fixed, non-zero number called the common ratio.
#' This function can only generate finite sequences of numbers, not infinite sequences.
#'
#' @param from Number. First term.  Scale factor, equal to the sequence's start value.
#' @param to Number. If the value closest to the last term in the finite series you want is not 'to' in the identity series, the value closest to 'to' and closest to 'from' in the identity series will be the last term.
#' If 'to' is contained on an geometric sequence, it is the last term.
#' @param by.ratio Number. Common ratio.
#' @param length.out Number. Desired length of the sequence. A non-negative number. It will be rounded up if fractional.
#'
#' @details
#' Numerical inputs should all be finite (that is, not infinite, NaN or NA).
#'
#' @return
#' numeric arguments return a vector of type integer or double: programmers should not rely on which.
#'
#' @seealso
#' \code{\link[base]{seq}}
#'
#' @examples
#' seq_geometric(1, 10, 2)
#' seq_geometric(1, 10, 2, length.out = 3)
#' seq_geometric(1, 0.001, 0.1)
#' seq_geometric(1, 0.001, 0.1, length.out = 3)
#' @export

seq_geometric <- function(from, to, by.ratio, length.out = NULL){
  if(!is.numeric(from)) from <- suppressMessages(as.numeric(from))
  if(!is.numeric(to)) to <- suppressMessages(as.numeric(to))
  if(!is.numeric(by.ratio)) by.ratio <- suppressMessages(as.numeric(by.ratio))

  if(length(from) == 0 || length(to) == 0 || length(by.ratio) == 0 ||
     !is.finite(from) || !is.finite(to) || !is.finite(by.ratio))
    stop("If you enter a value other than a number, the calculation will not work.", call. = FALSE)
  if(from == 0 || by.ratio == 0 || abs(by.ratio) == 1)
    stop("If the multiplier is 0 or 1, it cannot be calculated.", call. = FALSE)
  if((from * to * by.ratio < 0) ||
     (abs(from) < abs(to) && abs(to) > 1 && abs(by.ratio) < 1) ||
     (abs(from) > abs(to) && abs(to) < 1 && abs(by.ratio) > 1))
    stop("The calculation results do not converge.", call. = FALSE)
  if(!is.null(length.out) && (!is.finite(length.out) || length.out < 1))
    stop("Only positive finite numbers greater than 1 are accepted for length.out")

  if(!is.null(length.out)) length.out_ans <- length.out - 1
  if(is.null(length.out)) length.out_ans <- log(abs(to) / abs(from), by.ratio)

  ans <- from * by.ratio ^ (0:length.out_ans)
  if(!is.null(length.out) && abs(from) <= abs(to)) ans <- subset(ans, abs(ans) <= abs(to))
  if(!is.null(length.out) && abs(from) > abs(to)) ans <- subset(ans, abs(ans) >= abs(to))

  ans
}
