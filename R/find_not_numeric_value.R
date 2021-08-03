#' Find Where Values in the Vector that cannot be Converted to Numbers
#' @description
#' This function is used to find the where in the vector there are values that cannot be converted to numbers.
#' The result will be the location of the value that cannot be converted to a number in the vector by default.
#' @param x vector to examine.
#' @param where Choose whether to indicate where there are values that cannot be converted to numbers, either as numbers or logical types.
#' @export

find.not.numeric.value <- function(x, where = c("number", "logical")){
  where <- match.arg(where)

  if(!is.vector(x)){
    warning("only vectors can be handled.")
    return(NA)
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
