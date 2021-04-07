#' Scaling and Centering of Data Frame Objects
#' @description
#' \code{scale.data.frame} is generic function whose default method centers and/or scales the columns of a numeric in data frame.
#' The non-numeric values in the data frame will remain unchanged.
#'
#' In short, it is a generic function of \code{scale}.
#'
#' @param x a data frame object.
#' @param center either a logical value or numeric-alike vector of length equal to the number of columns of data frame, where ‘numeric-alike’ means that \code{\link[base]{as.numeric}}(.) will be applied successfully if \code{\link[base]{is.numeric}}(.) is not true.
#' @param scale either a logical value or a numeric-alike vector of length equal to the number of columns of data frame.
#'
#' @return
#' a data frame object.
#'
#' @seealso
#' \code{\link[base]{scale}}
#'
#' @export

scale.data.frame <- function(x, center = TRUE, scale = TRUE){
  if(class(x) != "data.frame"){
    warning("Only one data frames can be handled.")
    return(NA)
  }

  ans.list <- lapply(x, function(x){
    if(is.numeric(as.matrix(x))) scale.default(x, center, scale)
    else x
  })

  do.call(cbind.data.frame, ans.list)
}
