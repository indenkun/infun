#' Find Where Values in the Vector that cannot be Converted to Numbers
#' @description
#' This function is used to find the where in the vector or data frame there are values that cannot be converted to numbers.
#' The result will be the location of the value that cannot be converted to a number in the vector by default.
#' @param x vector or data frame to examine.
#' @param where Choose whether to indicate where there are values that cannot be converted to numbers, either as numbers or logical types.
#' @seealso
#' If a data frame of more than two dimensions is entered, returns the column numbers where the columns contain values that cannot be converted to numbers.
#' @export

find.not.numeric.value <- function(x, where = c("number", "logical")){
  where <- match.arg(where)

  if(!is.atomic(x) && !is.data.frame(x)){
    warning("only vectors or data frame can be handled.")
    return(NA)
  }

  if(is.data.frame(x) && dim(x)[2] == 1){
    x <- as.vector(as.matrix(x))
  }

  output.df <- data.frame(do.call(rbind, purrr::map(x, purrr::quietly(as.numeric))))

  unname(
    if(where == "number"){
      if(length(which(output.df$warnings != "character(0)")) > 0) which(output.df$warnings != "character(0)")
      else NA
    }
    else if(where == "logical") output.df$warnings != "character(0)"
  )
}
