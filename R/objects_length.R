#' Examine and Compare the Length of Objects
#' @description
#' A set of functions to check and compare the length of objects
#' \code{objects_length} returns the length value of the input object as a vector.
#' \code{objects_length_all_equal} returns TRUE if the lengths of all input objects are equal, and FALSE if any one of them is different.
#' \code{objects_length_num_equal} returns TRUE if the length of the input object is at least one equal to the length specified by .num.
#' \code{objects_length_num_equal_quantity} returns the number of input objects whose length is equal to the length specified by .num. If .quantity is specified, it will return TRUE if the answer is equal to the specified number.
#' @param ... Object to be examined.
#' @param .num The length of the object you want to examine. It accepts multiple values, and if more than one value is entered, it checks if the length of one of the entered values matches.
#' @param .quantity The number of objects you want to check that match the length of the object you want to check. It accepts multiple values, and if more than one value is entered, it checks if the length of one of the entered values matches.
#' @examples
#' x <- 1:3
#' y <- 1:6
#' z <- 1:3
#' objects_length(x, y, z)
#' objects_length_all_equal(x, y, z)
#' objects_length_num_equal(x, y, z, .num = 6)
#' objects_length_num_equal_quantity(x, y, z, .num = 3)
#' objects_length_num_equal_quantity(x, y, z, .num = 3, quantity = 2)
#' @export
#' @rdname objects_length
objects_length <- function(...){
  unname(sapply(eval(substitute(alist(...))), function(...){
    length(eval(...))
  }))
}

#' @export
#' @rdname objects_length
objects_length_all_equal <- function(...){
  ans <- objects_length(...)
  if(length(ans) >= 2){
    all(ans[-1] == ans[1])
  }else{
    stop("There's nothing to compare it to.")
  }
}

#' @export
#' @rdname objects_length
objects_length_num_equal <- function(..., .num = 1){
  if(!is.numeric(.num)){
    stop(".num must be a number.")
  }

  .num <- ceiling(.num)

  ans <- objects_length(...)

  any(ans %in% .num)
}

#' @export
#' @rdname objects_length
objects_length_num_equal_quantity <- function(..., .num = 1, .quantity = NULL){
  if(!is.numeric(.num) || !(is.numeric(.quantity) || is.null(.quantity))){
    stop(".num and .quantity must be a number.")
  }

  .num <- ceiling(.num)

  ans <- objects_length(...)

  if(is.null(.quantity)){
    sum(ans %in% .num)
  }else{
    .quantity <- ceiling(.quantity)
    sum(ans %in% .num) %in% .quantity
  }
}
