#' Labels to Vertical Writing System
#'
#' @description
#' \code{label_vetical} is function to convert the axis labels of a ggplot2 format graph to a vertical writing system.
#' \code{vertical_list} is the list includes formulas for converting basic horizontal bars to vertical bars.
#'
#' @param replace_list Specifies what to replace the string with, either in expression form or in list form containing expression forms. If no replacements are needed, specify NULL.
#'
#' @details
#' It does not actually realize the vertical writing system, but actually just changes lines one character at a time.
#' If horizontal bars are not replaced with vertical bars, unnatural Japanese notation may result.
#'
#' @rdname lavel_vertical
#' @export

label_vertical <- function(replace_list = vertical_list()){
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
    unlist(lapply(strsplit(split="", x), paste0, collapse = "\n"))
  }
}

#' @rdname lavel_vertical
#' @export

vertical_list <- function(){
  list("\u30fc" ~ "\uff5c",
       "-" ~ "\u2758")
}
