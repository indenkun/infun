#' Create dummy coded variables
#' @description
#' Given a variable x with n distinct values, create n new dummy coded variables coded 0/1 for presence (1) or absence (0) of each variable.
#' This function can be used to create a dummy code by splitting a single value into multiple values separated by commas or other delimiters by specifying any delimiter character.
#' @param x a vector or one column of data frame to be transformed into dummy codes
#' @param split a character (or object which can be coerced to such) containing regular expression to use for splitting. If empty matches occur, in particular if split has length 0, x is split into single characters.
#' @param variables a vector, The default is NULL, which refers to x and estimates the specified value, but if specified it checks and applies to the variable.
#' @param prefix a String to be prefix to the column name in the dummy code data frame
#' @param suffix a String to be suffix to the column name in the dummy code data frame
#' @param ... Other arguments to carry over to \code{\link[base]{strsplit}}.
#' @return  a data.frame of dummy coded variables.
#' @examples
#' df_sample <- data.frame(sample = c("a,b", "b", "c", "c,a", "a,b,c"))
#' (df_dummy <- dummy_code(df_sample$sample, split = ","))
#' new_df <- cbind(df_sample, df_dummy)
#' new_df
#' (df_dummy_v <- dummy_code(df_sample$sample, split = ",", variables = c("a", "b", "c", "d")))
#' new_df_v <- cbind(df_sample, df_dummy_v)
#' new_df_v
#' @export

dummy_code <- function(x, split, variables = NULL, prefix = NULL, suffix = NULL, ...){
  if(!is.atomic(x) && !is.data.frame(x))
    stop("'x' accepts only vector or data frames.")
  if(is.data.frame(x) && ncol(x) != 1)
    stop("Only one column of data frame is accepted.")
  if(length(split) != 1)
    stop("Multiple 'split' is not accepted.")
  if(!is.null(variables) && !is.atomic(variables))
    stop("'variables' accepts only vector.")
  if(!is.null(prefix) && length(prefix) != 1)
    stop("Only one 'prefix' is accepted.")
  if(!is.null(suffix) && length(suffix) != 1)
    stop("Only one 'suffix' is accepted.")

  value_list <- strsplit(unlist(x), split = split)
  colname_list <- if(is.null(variables)) unique(unlist(value_list))
                  else variables

  res <- as.data.frame(do.call(rbind, lapply(value_list, function(x){
    as.numeric(colname_list %in% x)
  })))
  colnames(res) <- paste0(prefix, colname_list, suffix)
  res
}
