#' Replace the value that exactly matches the pattern with a replacement
#'
#' @description
#' Function to replace a value that exactly matches a pattern with a replacement.
#' Given a vector of equal length for pattern and replacement, the first value of pattern is interpreted as replacing the first value of replacement.
#' See the argument descriptions for details.
#' @param x Vector of values to be converted.
#' @param pattern The value of the pattern to be converted or a vector containing it.
#' If given in a vector of two or more lengths, it is determined that it should be replaced by a value equal to the position of each of the values given in the replacement argument.
#' @param replacement The value of the replacement to be converted or a vector containing it.
#' If given in a vector of two or more lengths, it is determined that it should be replaced by a value equal to the position of each of the values given in the pattern argument.
#' @param nomatch Specifies the value to return if there is no matching pattern and replacement value. If no value is specified, the original x value is returned.
#' @examples
#' values <- c("HOKKAIDOU", "hokkaidou", "TOUHOKU", "touhoku")
#' pattern <- c("hokkaidou", "touhoku")
#' replacement <- c("HOKKAIDOU", "TOUHOKU")
#' replace_match(values, pattern, replacement)
#' replace_match(values, pattern, replacement, nomatch = NA)
#' @export

replace_match <- function(x, pattern, replacement, nomatch){
  if(length(pattern) != length(replacement))
    stop("pattern length must be same length that replacement.")

  ans <- match(x, pattern)
  if(any(is.na(ans))){
    res <- length(ans)
    for(i in 1:res){
      if(is.na(ans[i])){
        if(missing(nomatch)) res[i] <- x[i]
        else res[i] <- nomatch
      }else{
        res[i] <- replacement[ans[i]]
      }
    }
  }else{
    res <- replacement[ans]
  }
  return(res)
}
