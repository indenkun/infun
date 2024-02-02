#' Access The Package README in a Browser
#' @description
#' Access The Package README in a Browser.
#' With the package installed, access the README of the installed package from CRAN or GitHub with a browser.
#' @param package The name of the package whose README you want to refer to. String. You can specify only one package, and it must be installed.
#' @details
#' We refer to the package's Description to determine whether it was installed from CRAN, GitHub, or otherwise.
#'
#' If the package was installed from CRAN, it accesses the CRAN package web page with the README; if there is no README, an empty web page is displayed.
#'
#' If the package was installed from GitHub, the web page of package on the GitHubis accessed.
#'
#' @export

readme <- function(package){
  if(length(package) != 1) stop("Only one package name can be specified.")
  if(!is.character(package)) stop("The package name must be specified as a string.")
  repository_info <- packageDescription(package)[c("Repository", "GithubRepo", "GithubUsername")]
  if(!is.null(repository_info$Repository) && repository_info$Repository == "CRAN")
    browseURL(paste0("https://cran.r-project.org/web/packages/",
                     package,
                     "/readme/README.html"))
  else if(!is.null(repository_info$GithubRepo))
    browseURL(paste0("https://github.com/",
                     repository_info$GithubUsername,
                     "/",
                     repository_info$GithubRepo))
  else stop("Only packages installed from CRAN or GitHub are supported.")
}
