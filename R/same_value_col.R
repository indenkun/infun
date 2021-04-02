#' Find Columns Consisting of the Same Value in a Data Frame
#' @description
#' This function is used to find a column consisting of the same value in a data frame.
#' The answer will be returned in a list format, and those that have the same value in the column number or column name will be output.
#' @param data Data frame to check if there is a column consisting of the same value.
#' @param col.name Select whether the columns are represented by column names or by column numbers. The default value is the column number.
#'
#' @return a list.
#' @export

same.value.col <- function(data, col.name = c("number", "name")){
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
