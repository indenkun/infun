#' Find Where Values in the Vector that non-integer
#' @description
#' This function is used to find a non-integer value in a vector.
#' The input value can be of any type, but it must be a vector of numbers only.
#' If a string or other value is entered, a warning message will be displayed and NA will be returned.
#' @param x vector or data frame to examine.
#' @param where Choose whether to indicate where there are values that cannot be converted to numbers, either as numbers or logical types.
#' @seealso
#' If a data frame of more than two dimensions is entered, returns the column numbers where the columns contain values that cannot be converted to numbers.
#' @export

find.not.integer.value <- function(x, where = c("number", "logical")){
  where <- match.arg(where)

  if(!is.vector(x) && !is.data.frame(x)){
    warning("only vectors or data frame can be handled.")
    return(NA)
  }

  if(all(!(find.not.numeric.value(x, "logical")))){
    x <- if(is.vector(x)){
      as.numeric(x)
    }else{
      purrr::map_df(x, as.numeric)
    }
  }else{
    warning("there are any values that not numeric value.")
    return(NA)
  }

  ans <- if(is.data.frame(x) && ncol(x) >= 2){
    purrr::map_lgl(x, function(x){
      any(trunc(x) != x)
    })
  }else{
    trunc(x) != x
  }

  ans <- unname(ans)

  if(where == "number"){
    if(all(!(ans))) NA
    else which((ans))
  }else{
    as.vector(ans)
  }
}
