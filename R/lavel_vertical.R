#' Labels to Vertical Writing System
#'
#' @description
#' \code{label_vetical} is function to convert the axis labels of a ggplot2 format graph to a vertical writing system.
#' \code{vertical_list} is the list includes formulas for converting basic horizontal bars to vertical bars.
#'
#' @param replace_list Specifies what to replace the string with, either in expression form or in list form containing expression forms. If no replacements are needed, specify NULL.
#' @param line_feed Enter a key character or escape sequence for line breaks. This is given directly to \code{\link[base]{strsplit}} as an argument, so it must be in an acceptable form. If NULL is given, no line breaks will be made.
#' @param blank_space Adjust the blanks to adjust for slight misalignment in strings that have no characters on the adjacent line when breaking lines. Please enter the required amount. If you enter a string or other text, the string will be output where there is no string.
#'
#' @details
#' It does not actually realize the vertical writing system, but actually just changes lines one character at a time.
#' If horizontal bars are not replaced with vertical bars, unnatural Japanese notation may result.
#'
#' The function to express line breaks when the text consists only of Japanese has been provided, but there is a possibility of misalignment when half-width characters are included or when proportional fonts are used.
#'
#' @rdname lavel_vertical
#' @export

label_vertical <- function(replace_list = vertical_list(), line_feed = NULL, blank_space = "    "){
  function(x){
    if(!is.null(replace_list)){
      list_is_formula <- unlist(lapply(replace_list, function(x){"formula" == class(x)}))
      if(all(list_is_formula)){
        for(i in replace_list){
          x <- gsub(i[[2]], i[[3]], x)
        }
      }else if("formula" == class(replace_list)){
        x <- gsub(replace_list[[2]], replace_list[[3]], x)
      }else{
        stop("the replace_list must be in the formula format, in list.")
      }
    }
    if(is.null(line_feed)){
      unlist(lapply(strsplit(split="", x), paste0, collapse = "\n"))
    }else{
      unlist(lapply(x, function(x){
        x <- unname(unlist(sapply(x, strsplit, line_feed)))
        label_text <- character()
        for(i in 1:max(nchar(x))){
          m <- unname(sapply(x, function(x){
            substr(x, i, i)
          }))
          m <- sapply(m, function(x){
            if(x == "") blank_space
            else x
          })
          if(length(label_text) == 0) label_text <- paste0(paste0(rev(m), collapse = ""), "\n")
          else label_text <- paste0(label_text, paste0(paste0(rev(m), collapse = ""), "\n"))
        }
        label_text
      }
      ))
    }
  }
}

#' @rdname lavel_vertical
#' @export

vertical_list <- function(){
  list("\u30fc" ~ "\uff5c",
       "-" ~ "\u2758")
}
