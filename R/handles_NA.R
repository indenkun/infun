#' Handles data frames containing NA in a nice way.
#' @description
#' \code{remove_na_cols} deletes a column that consists only of \code{NA}. \code{remove_na_rows} deletes a rows that consists only of \code{NA}.
#' \code{consolidate_cols} retrieves a vector of values where each row of the specified data frame consists of NA and one other value, either with NA removed only or with NA if all values in the row are NA.
#' \code{check_onevalue_cols} is check funcion within \code{consolidate_cols}.
#'
#' @param data data frame
#' @param cols You can specify the columns you wish to process by specifying the column names contained in the data frame.
#'             If not specified, all columns of the data frame are processed.
#' @inheritParams base::`[`
#' @examples
#' d <- data.frame(value01 = c(1:3, NA),
#'                 value02 = c(1:2, NA, NA),
#'                 value03 = rep(NA, 4),
#'                 value04 = c(1:3, NA),
#'                 value05 = rep(NA, 4))
#' remove_na_cols(d)
#' remove_na_rows(d)
#'
#' d <- data.frame(id_1 = c(1:3, rep(NA, 6)),
#'                 id_2 = c(rep(NA, 3), 4:6, rep(NA, 3)),
#'                 id_3 = c(rep(NA, 6), 7:9))
#' consolidate_cols(d)
#' check_onevalue_cols(d)
#' @rdname Handles_NA
#' @export
remove_na_cols <- function(data, cols, drop = FALSE){
  if(!is.data.frame(data)) stop("data must be a data frame.")

  if(!missing(cols)){
    if(!any(colnames(data) %in% cols)) stop("cols must be a column name in the data frame")
    data_check <- data[, cols, drop = FALSE]
  }else data_check <- data
  data[apply(data_check, 1, function(x) !all(is.na(x))), drop = drop]
}

#' @rdname Handles_NA
#' @export
remove_na_rows <- function(data, cols){
  if(!is.data.frame(data)) stop("data must be a data frame.")

  if(!missing(cols)){
    if(!any(colnames(data) %in% cols)) stop("cols must be a column name in the data frame")

    cols_check <- colnames(data) %in% cols
    data <- mapply(function(x, y){
      if(!x) data[, y, drop = FALSE]
      else if(!all(is.na(data[, y]))) data[, y, drop = FALSE]
    }, cols_check, colnames(data))
    do.call(cbind.data.frame, data[!sapply(data, is.null)])
  }else{
    Filter(function(x) !all(is.na(x)), data)
  }
}

#' @rdname Handles_NA
#' @export
consolidate_cols <- function(data, cols){
  if(!is.data.frame(data)) stop("data must be a data frame.")

  value_na <- function(x){
    if(all(is.na(x))) NA
    else stats::na.omit(x)
  }
  stopifnot(if(missing(cols)) check_onevalue_cols(data)
            else check_onevalue_cols(data, cols))

  if(!missing(cols)){
    if(!any(colnames(data) %in% cols)) stop("cols must be a column name in the data frame")
    apply(data[, cols, drop = FALSE], 1, value_na)
  }else apply(data, 1, value_na)
}

#' @rdname Handles_NA
#' @export
check_onevalue_cols <- function(data, cols){
  if(!is.data.frame(data)) stop("data must be a data frame.")

  check_value_na <- function(x){
    if(all(is.na(x))) TRUE
    else sum(!is.na(x)) == 1
  }
  if(!missing(cols)){
    if(!any(colnames(data) %in% cols)) stop("cols must be a column name in the data frame")
    all(apply(data[, cols, drop = FALSE], 1, check_value_na))
  }else all(apply(data, 1, check_value_na))
}
