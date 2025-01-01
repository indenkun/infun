#' Return Parts of an Data Frame
#'
#' @description
#' Only display the specified number of rows and columns of the data frame are extracted, otherwise "..." and abbreviations are used to denote the rest.
#'
#' @param data an data frame
#' @param n an integer. Specify the number of rows you want to extract. The data is extracted from the beginning and end of the specified number of lines, so the data frame is the specified number of lines x 2 + ellipsis.
#' @param col_n an integer. Specify the number of rows you want to extract. The data is extracted from the beginning and end of the specified number of columns, so the data frame is the specified number of columns x 2 + ellipsis.
#' @details
#' If the specified number of rows and columns is greater than the original data frame, the data is display as it is.
#'
#' @examples
#' head_tail(iris)
#'
#' @export

head_tail <- function(data, n = 3L, col_n = 3L){
  stopifnot(is.data.frame(data))
  stopifnot(is.numeric(n) && is.numeric(col_n))
  stopifnot(n >= 1L && col_n >= 1L)

  data_row <- nrow(data)
  data_col <- ncol(data)

  if(n * 2 <=  data_row){
    data <- as.data.frame(lapply(data, as.character), row.names = row.names(data))
    data <- rbind.data.frame(utils::head(data, n = n),
                             as.data.frame(matrix("...", ncol = data_col,
                                                  dimnames = list("...", colnames(data)))),
                             utils::tail(data, n = n))
  }

  if(col_n * 2 <= data_col){
    if(col_n >= 2){
      data <- cbind.data.frame(data[1:col_n],
                               as.data.frame(matrix("...", nrow = nrow(data),
                                                    dimnames = list(rownames(data), "..."))),
                               data[(data_col - col_n + 1):data_col])
    }else{
      data <- cbind.data.frame(data[col_n],
                               as.data.frame(matrix("...", nrow = nrow(data),
                                                    dimnames = list(rownames(data), "..."))),
                               data[data_col])
    }
  }

  data
}

