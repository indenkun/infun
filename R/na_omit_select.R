#' Handling of NA in selected columns in a data frame
#' @description
#' If NA is present in a selected column in the data frame, returns a data frame with the rows containing NA in that column removed if the default is the case.
#' If \code{.retrieve = FALSE} is specified, only rows with NA in the chosen column are returned.
#' Multiple columns may be specified as the columns to be selected.
#' @param .data data frame
#' @param ... One or more unquoted expressions separated by commas. Variable names can be used as if they were positions in the data frame, so expressions like x:y can be used to select a range of variables.
#' @param .retrieve logical If TRUE, a data frame is returned excluding rows containing NA in the selected columns; if FALSE, a data frame is returned with only rows containing NA in the selected columns.
#' @export

na.omit_select <- function(.data, ..., .retrieve = TRUE){
  if(!requireNamespace("dplyr", quietly = TRUE)) stop("This function will not work unless the `{dplyr}` package is installed")

  select_case <- stats::complete.cases(dplyr::select(.data = .data, ...))
  if(.retrieve) .data[select_case, ]
  else .data[!select_case, ]
}
