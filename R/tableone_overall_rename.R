#' Change the Text of "Overall" in a Table created with tableone
#' @description
#' This function is used to change the "Overall" character in the item name of a table created with \code{\link[tableone]{CreateTableOne}} to any character.
#' @param x Object returned by CreateTableOne function contain the "Overall" character in the item name of a table.
#' @param rename.str The string that want to change from "Overall".
#' @return An object of class \code{TableOne}, which is a list of three objects.
#'
#' @seealso
#' \code{\link[tableone]{CreateTableOne}}, \code{\link[tableone]{print.TableOne}}, \code{\link[tableone]{summary.TableOne}}
#'
#' @export

tableone.overall.rename <- function(x, rename.str){
  if(class(x) != "TableOne"){
    warning("The class is not TableOne, so it cannot be handled.")
  }else{
    if(names(x[["ContTable"]])[1] != "Overall" || names(x[["CatTable"]])[1] != "Overall"){
      warning("There is no Overall in the table to rename.")
    }else{
      names(x[["ContTable"]])[1] <- rename.str
      names(x[["CatTable"]])[1] <- rename.str
    }
  }
  x
}
