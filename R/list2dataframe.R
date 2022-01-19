#' List Convert to dataframe
#' @description
#' Function to convert a list into a dataframe.
#' For list of different lengths, the data frame is constructed according to the longest list, and for short lists, the missing places are filled with NA according to the long list.
#' \code{list2data.frame_cbind} makes each element of the list a column.
#' \code{list2data.frame_rbind} makes each element of the list a row.
#' @param list list to be converted to a data frame
#' @rdname list2data.frame
#' @export

list2data.frame_cbind <- function(list){
  if(!is.list(list)){
    warning("This function only accepts lists.")
    return(NA)
  }
  max_l <- max(sapply(list, length))
  data.frame(lapply(list, `length<-`, max_l))
}

#' @rdname list2data.frame
#' @export
list2data.frame_rbind <- function(list){
  if(!is.list(list)){
    warning("This function only accepts lists.")
    return(NA)
  }
  max_l <- max(sapply(list, length))
  data.frame(do.call(rbind, lapply(list, `length<-`, max_l)))
}
