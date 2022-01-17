#' Look for any two columns of data frames that are interchangeable
#' @description
#' For any two columns specified in the data frame (say column A and B), if the combination of column A and B is the same even if they are swapped, it will return it as a data frame or a row number.
#' For example, if column A has "TOM" and "BOB", and the same respective row in column B has "BOB" and "TOM", the row will be extracted as interchangeable.
#' Also, when there is a row with the same value in column A and B, it is also determined to be interchangeable and extracted.
#'
#' @param data frame to examine.
#' @param x The column name to look up. The column name should be enclosed in double quotation marks.
#' @param y The column name to look up. The column name should be enclosed in double quotation marks.
#' @param out.put Selects whether to return the resulting output as a dataframe or by row name. The default is to return in a data frame.
#'
#' @return
#' Returns either the extracted data frame or a vector of row counts.
#'
#' @export

subset_interchange_col <- function(data, x, y, out.put = c("dataframe", "num")){
  out.put <- match.arg(out.put)

  if(!is.data.frame(data)){
    warning("only data frame can be handled.")
    return(NA)
  }

  if("1:nrow(data)" %in% colnames(data)){
    warning("Unable to process because the column name of the input data frame contains the column name \"1:nrow(data)\".
")
    return(NA)
  }

  data <- cbind.data.frame(data, 1:nrow(data))
  ans <- purrr::map2_df(data[[x]], data[[y]], function(m, n){
    subset(data, data[[x]] == n & data[[y]] == m)
  })
  ans_num <- sapply(unique(ans[["1:nrow(data)"]]), function(x){
    min(which(data[["1:nrow(data)"]] %in% x))
  })

  ans <- data[ans_num,]
  ans <- ans[order(ans[["1:nrow(data)"]]),]

  if(out.put == "dataframe"){
    subset(ans, select = 1:(ncol(ans) - 1))
  }else if(out.put == "num"){
    ans[["1:nrow(data)"]]
  }
}
