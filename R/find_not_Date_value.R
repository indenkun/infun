#' Find Where Values in the Vector that cannot be Converted to Date
#' @description
#' \code{find.not.as_date.value} is used to find the where in the vector there are values that cannot be converted to \code{\link[base]{Date}} using \code{\link[lubridate]{as_date}} in \code{lubridate}.
#' \code{find.not.as.Date.value} is used to find the where in the vector there are values that cannot be converted to \code{\link[base]{Date}} using \code{\link[base]{as.Date}} in \code{base}.
#' The result will be the location of the value that cannot be converted to a number in the vector by default.
#' @param x vector to examine.
#' @param where Choose whether to indicate where there are values that cannot be converted to numbers, either as numbers or logical types.
#' @note
#' There is a slight difference between the values that can be converted to Date by \code{lubridate}'s \code{as_date} and those that can be converted by \code{base}'s \code{as.Date}.
#' \code{as_date} converts even relatively fuzzy forms if they can be changed to a \code{Date} class, while \code{as.Date} operates relatively more strictly.
#' @rdname find.not.Date.value
#' @export

find.not.as_date.value <- function(x, where = c("number", "logical")){
  where <- match.arg(where)

  if(!requireNamespace("lubridate", quietly = TRUE)) stop("This function will not work unless the `{lubridate}` package is installed")

  if(!is.vector(x)){
    warning("only vectors can be handled.")
    return(NA)
  }

  output.df <- data.frame(do.call(rbind, purrr::map(x, purrr::quietly(lubridate::as_date))))

  unname(
    if(where == "number"){
      if(length(which(output.df$warnings != "character(0)")) > 0) which(output.df$warnings != "character(0)")
      else NA
    }
    else if(where == "logical") output.df$warnings != "character(0)"
  )
}

#' @rdname find.not.Date.value
#' @export

find.not.as.Date.value <- function(x, where = c("number", "logical")){
  where <- match.arg(where)

  if(!requireNamespace("lubridate", quietly = TRUE)) stop("This function will not work unless the `{lubridate}` package is installed")

  if(!is.vector(x)){
    warning("only vectors can be handled.")
    return(NA)
  }

  output.df <- data.frame(do.call(rbind, purrr::map(x, purrr::safely(as.Date))))

  unname(
    if(where == "number"){
      if(length(which(output.df$error != "NULL")) > 0) which(output.df$error != "NULL")
      else NA
    }
    else if(where == "logical") output.df$error != "NULL"
  )
}
