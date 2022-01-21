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
  if(!requireNamespace("dplyr", quietly = TRUE)) stop("This function will not work unless the `{dplyr}` package is installed")

  # Determine if it is a list.
  if(!is.list(list)){
    warning("This function only accepts lists.")
    return(NA)
  }
  # Check if the depth of the list is 1.
  depth_n <- purrr::map_int(list, purrr::vec_depth)
  if(max(depth_n) != 1){
    warning("Lists that are nested more than once cannot be processed.")
    return(NA)
  }
  # Checking if an element in a list is a vector.
  if(!any(sapply(list, is.vector))){
    warning("Cannot process the list because its elements are non-vector.")
    return(NA)
  }
  # Check if the elements in the list have the same length.
  list_length <- sapply(list, length)
  max_length <- max(list_length)
  length_equal <- all(list_length %in% max_length)
  # Checking if a list element contains a name.
  name_list_log <- sapply(list, function(x){
    sapply(lapply(list, names), is.null)
  })
  if(all(name_list_log) == any(name_list_log)){
    if(all(name_list_log)){
      name_list_NA <- sapply((lapply(lapply(list, names), is.na)), all)
      if(!all(name_list_NA)){
        warning("Cannot process the vectors in the list elements because they are a mixture of named and unnamed vectors.")
        return(NA)
      }
    }
  }else{
    warning("Cannot process some vectors in the list because some of them have names and some don't.")
    return(NA)
  }

  if(all(name_list_log)){
    data.frame(lapply(list, `length<-`, max_length))
  }else{
    list_name <- unique(unlist(lapply(list, names)))
    list_reoder <- lapply(list, function(x){
      x[list_name]
    })
    `rownames<-`(as.data.frame(dplyr::bind_cols(list_reoder)), list_name)
  }
}

#' @rdname list2data.frame
#' @export
list2data.frame_rbind <- function(list){
  if(!requireNamespace("dplyr", quietly = TRUE)) stop("This function will not work unless the `{dplyr}` package is installed")

  # Determine if it is a list.
  if(!is.list(list)){
    warning("This function only accepts lists.")
    return(NA)
  }
  # Check if the depth of the list is 1.
  depth_n <- purrr::map_int(list, purrr::vec_depth)
  if(max(depth_n) != 1){
    warning("Lists that are nested more than once cannot be processed.")
    return(NA)
  }
  # Checking if an element in a list is a vector.
  if(!any(sapply(list, is.vector))){
    warning("Cannot process the list because its elements are non-vector.")
    return(NA)
  }
  # Check if the elements in the list have the same length.
  list_length <- sapply(list, length)
  max_length <- max(list_length)
  length_equal <- all(list_length %in% max_length)
  # Checking if a list element contains a name.
  name_list_log <- sapply(list, function(x){
    sapply(lapply(list, names), is.null)
  })
  if(all(name_list_log) == any(name_list_log)){
    if(all(name_list_log)){
      name_list_NA <- sapply((lapply(lapply(list, names), is.na)), all)
      if(!all(name_list_NA)){
        warning("Cannot process the vectors in the list elements because they are a mixture of named and unnamed vectors.")
        return(NA)
      }
    }
  }else{
    warning("Cannot process some vectors in the list because some of them have names and some don't.")
    return(NA)
  }

  if(all(name_list_log)){
    # Handling of unnamed lists.
    data.frame(do.call(rbind, lapply(list, `length<-`, max_length)))
  }else{
    # Handling of named lists.
    `rownames<-`(as.data.frame(dplyr::bind_rows(list)), names(list))
  }
}
