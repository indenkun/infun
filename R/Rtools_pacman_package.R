#' List of pacman packages in Rtools
#' @description
#' These are functions to search for packages that can be installed by Rtools' pacman. In short, it is a wrapper for some of the functions of pacman in Rtools.
#' \code{Rtools.pacman.package.list()} is a function that outputs a list of packages that can be installed by Rtools pacman from repository. By specifying arguments, you can extract only those packages that are already installed, or only those that are yet uninstalled.
#' \code{Rtools.pacman.package.find()} is a function that displays a list of packages that can be installed by pacman in Rtools from repository with the specified arguments in the string. If no matching package is found, return NA.
#'
#' @param package.list Select whether to show all packages, only installed packages, or only packages that have not yet been uninstalled.
#' @param x A String. Specify the string contained in the package to be searched.
#'
#' @details
#' Cannot be used except in a Windows environment where Rtools40 or later is installed.
#'
#' @return
#' a Vector of package names.
#'
#' @rdname Rtools.pacman.package
#' @export

Rtools.pacman.package.list <- function(package.list = c("all", "installed", "uninstalled")){
  package.list <- match.arg(package.list)

  if(.Platform$OS.type != "windows"){
    warning("This function is for Windows.")
    return(NA)
  }

  pacman.result <- purrr::map("pacman -Sl", purrr::quietly(shell), intern = TRUE)

  if(length(pacman.result[[1]][["warnings"]]) == 1){
    warning("You may not have pacman installed since Rtools40.")
    return(NA)
  }else{
    pacman.packages.list <- unlist(pacman.result[[1]][["result"]], use.names = FALSE)
    if(package.list == "all") pacman.packages.list
    else if(package.list == "installed") pacman.packages.list[grep("installed", pacman.packages.list)]
    else if(package.list == "uninstalled") pacman.packages.list[-grep("installed", pacman.packages.list)]
  }
}

#' @rdname Rtools.pacman.package
#' @export

Rtools.pacman.package.find <- function(x){

  if(.Platform$OS.type != "windows"){
    warning("This function is for Windows.")
    return(NA)
  }

  if(length(x) != 1){
    warning("'x' must be of length 1")
    return(NA)
  }

  find.name <- paste("pacman -Ss", x)

  pacman.result <- purrr::map(find.name, purrr::quietly(shell), intern = TRUE)
  if(length(pacman.result[[1]][["warnings"]]) == 1){
    warning("You may not have pacman installed since Rtools40.")
    return(NA)
  }else{
    pacman.packages.list <- unlist(pacman.result[[1]][["result"]], use.names = FALSE)
    if(length(pacman.packages.list) == 0){
      warning("It seems that the appropriate package was not found.")
      return(NA)
    }else{
      pacman.packages.list[1:length(pacman.packages.list) %% 2 != 0]
    }
  }
}
