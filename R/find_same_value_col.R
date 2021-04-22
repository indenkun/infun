#' Find Columns Consisting of the Same Value in a Data Frame
#' @description
#' This function is used to find a column consisting of the same value in a data frame.
#' The answer will be returned in a list format, and those that have the same value in the column number or column name will be output.
#' \code{unique_col} is a function to remove duplicate columns in a data frame, the column version of \code{base}'s \code{\link[base]{unique}}.
#' @param data Data frame to check if there is a column consisting of the same value.
#' @param col.name Select whether the columns are represented by column names or by column numbers. The default value is the column number.
#'
#' @rdname find.same.value.col
#'
#' @return a list.
#' @export

find.same.value.col <- function(data, col.name = c("number", "name")){
  col.name = match.arg(col.name)

  if(!is.data.frame(data)){
    warning("only data frames can be handled.")
    return(NA)
  }

  same.value.col.list <- vector("list", ncol(data))
  if(col.name == "name") names(same.value.col.list) <- names(data)

  for(i in 1:ncol(data)){
    same.value.col.number <- NULL
    for(k in 1:ncol(data))
      if(all(data[i] == data[k]) && i != k){
        if(col.name == "number") same.value.col.list[i] <- c(same.value.col.number, k)
        else same.value.col.list[i] <- c(same.value.col.number, names(data)[k])
      }
  }

  same.value.col.list
}

#' @rdname find.same.value.col
#' @export

unique_col <- function(data){
  if(!is.data.frame(data)){
    warning("only data frames can be handled.")
    return(NA)
  }
  data[!duplicated(as.list(data))]
}
