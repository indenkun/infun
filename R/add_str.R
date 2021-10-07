#' Combine All the Items in a Specific Column of a Data Frame with any String of Characters
#' @description
#' Combine all the items in a specific column of a data frame with any string of characters in the original data frame.
#' Only data frames are supported.
#' The converted column will be a string because it contains strings such as ALL.
#' @param data Specify the data frame to be converted. No other data frame is accepted.
#' @param key Specify the name of the column where you want to convert the value to ALL, etc. and combine them. If the column name does not exist in the data frame, an error occurs.
#' @param add.string Specifies an any string. Convert the specified column to any string of characters. The default value is ALL.
#'
#' @return a data frame.
#'
#' @export

add.str <- function(data, key, add.string = "ALL"){
  if(!is.data.frame(data)){
    warning("only data frames can be handled.")
    return(NA)
  }
  if(!all(purrr::map_lgl(key, function(key){
    key %in% colnames(data)
  }))){
    warning("the column name must be the name contained in the original data frame.")
    return(NA)
  }

  rbind(data, replace(data, key, add.string))
}
