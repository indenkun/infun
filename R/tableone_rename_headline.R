#' Change the Text of headline in a Table created with tableone
#' @description
#' These functions are used to change the headline character in the item name of a table created with \code{\link[tableone]{CreateTableOne}} to any character.
#' \code{tableone.rename.overall} is a function that changes only the Overall of the table heading to an arbitrary character.
#' \code{tableone.rename.headline} is a function that change any heading (including Overall) to any character by setting the table heading as an formula before and after the change.
#'
#' @param x Object returned by CreateTableOne function contain name of the heading to be changed.
#' @param rename.str The string that want to change from "Overall".
#' @return An object of class \code{TableOne}, which is a list of three objects.
#'
#' @seealso
#' \code{\link[tableone]{CreateTableOne}}, \code{\link[tableone]{print.TableOne}}, \code{\link[tableone]{summary.TableOne}}
#'
#' @rdname tableone.rename.headline
#'
#' @export

tableone.rename.overall <- function(x, rename.str){
  if(length(rename.str) != 1){
    warning("'rename.str' must be of length 1")
    return(NA)
  }

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


#' @param rename.headline Enter the name of the heading to be changed in formula form.
#' If you want to change more than one heading, combine the formulas into a list format.
#' Names that contain hyphens will be evaluated as negative in the formula, so they must be enclosed in quotation marks.
#' @rdname tableone.rename.headline
#'
#' @export

tableone.rename.headline <- function(x, rename.headline){

  if(class(x) != "TableOne"){
    warning("The class is not TableOne, so it cannot be handled.")
  }else if(class(rename.headline) != "list" && class(rename.headline) != "formula"){
    warning("The name of the heading you want to change should be specified before and after the change in the 'formula'.")
  }else if(class(rename.headline) == "list" && !all(sapply(rename.headline, function(x) class(x)) %in% "formula")){
    warning("The name of the heading you want to change should be in the 'list' format, with the before and after values specified in the 'formula'.")
  }else if(class(rename.headline) == "list" && !all(lapply(rename.headline, function(x) length(x[[2]])) %in% 1)){
    warning("Only one name can be specified before the change.")
  }else if(class(rename.headline) == "list" && !all(lapply(rename.headline, function(x) length(x[[3]])) %in% 1)){
    warning("Only one name can be specified after the change.")
  }else if(!all(names(x[["ContTable"]]) == names(x[["CatTable"]]))){
    warning("The table object may have already been changed in an inconsistent way and cannot be adjusted by this function.")
  }else{
    before.headline.name <- if(class(rename.headline) != "list"){
      as.character(rename.headline[[2]])
    }else{
      sapply(rename.headline, function(x){
        as.character(x[[2]])
      })
    }

    after.headline.name <- if(class(rename.headline) != "list"){
      as.character(rename.headline[[3]])
    }else{
      sapply(rename.headline, function(x){
        as.character(x[[3]])
      })
    }

    if(any(c(before.headline.name, after.headline.name) %in% "test")){
      warning("The word 'test' is not well specified in what is specified before or after the change, so it cannot work.")
      return(x)
    }

    tableone.headline.name <- names(x[["ContTable"]])

    match.table.headline.name <- before.headline.name %in% tableone.headline.name

    if(!all(match.table.headline.name)){
      warning("It is possible that a heading name that does not exist in the table is specified as the target of the change.")
    }

    before.headline.name <- before.headline.name[match.table.headline.name]
    after.headline.name <- after.headline.name[match.table.headline.name]

    for(i in 1:length(before.headline.name)){
      names(x[["ContTable"]])[names(x[["ContTable"]]) == before.headline.name[i]] <- after.headline.name[i]
      names(x[["CatTable"]])[names(x[["CantTable"]]) == before.headline.name[i]] <- after.headline.name[i]
    }
  }
  x
}
