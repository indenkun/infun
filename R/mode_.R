#' Calculate mode of data frame
#' @description
#' Calculate the mode frequency for each column of the data frame.
#' @param data a data frame.
#' @details
#' The result is in the form of a data frame that returns answers in the form of column name, mode, and frequency.
#' More than one answer may be returned for a column as the mode may not be uniquely obtained.
#' @examples
#' mode_data.frame(iris)
#' @export

mode_data.frame <- function(data){
  stopifnot(is.data.frame(data))
  df_colnames <- colnames(data)
  res <- NULL

  for(i in df_colnames){
    res_for <- mode_(data[i])
    res_for[[3]] <- colnames(res_for[1])
    colnames(res_for) <- c("value", "Freq", "colnames")
    rownames(res_for) <- NULL
    res <- rbind(res, res_for)
  }

  res[c("colnames", "value", "Freq")]
}

#' Calculate mode
#' @description
#' Given a vector or a data frame, it calculates the mode and frequency.
#' @param ... Accepts vectors and data frames.
#' @details
#' If multiple columns of data frames are given, the most frequent combination of combinations and frequencies is computed.
#' Large data frames cannot be calculated properly.
#' @export

mode_ <- function(...){
  d <- table(...)
  d <- data.frame(d)
  freqcol <- colnames(d)[length(colnames(d))]
  res <- d[d[freqcol] == max(d[freqcol]),]
  rownames(res) <- NULL
  res
}
