#' Delete a string of characters sandwiched between specific characters
#' @description
#' Delete a string of characters sandwiched between specific characters.
#'
#' @details
#' The specified string must be a single character, and the first and last characters of the string must be different.
#'
#' @param string Input vector. Either a character vector, or something coercible to one.
#' @param start_pattern Specifies the first character of the string to be deleted. It must be different from the last character, \code{end_pattern}.
#' @param end_pattern Specifies the last character of the string to be deleted. It must be different from the first character, \code{start_pattern}.
#' @param perl logical. Should Perl-compatible regexps be used?
#'
#' @export

str_remove_sandwich <- function(string, start_pattern, end_pattern, perl = FALSE){
  if(nchar(start_pattern) != 1 ||
     nchar(end_pattern) != 1 ||
     start_pattern == end_pattern){
    warning("The starting or ending letter must always be a single different letter.")
    return(NA)
  }

  end_pattern <- paste0(".+", end_pattern)

  unname(sapply(string, function(string){
    string <- unlist(strsplit(string, split = start_pattern, perl = perl))
    string <- unlist(strsplit(string, split = end_pattern, perl = perl))
    paste0(string, collapse = "")
  }))
}
