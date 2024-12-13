#' To Times Objects from POSIX or Chron Objects
#' @description
#' Create a \code{times} object in the \code{chron} package by taking only the elements of time from a \code{POSIXlt} or \code{POSIXct} object or \code{chron} object in \code{chron} package.
#' @param x \code{POSIXct} or \code{PSIXlt} objcet or \code{chron} object to be converted to \code{times} object.
#' @inheritParams base::strftime
#' @details
#' If the \code{POSIXct} object differs from the system time zone, the time zone must also be specified within \code{to_times}.
#' @examples
#' x <- as.POSIXlt(Sys.time())
#' to_times(x)
#' @export
to_times <- function(x, tz = ""){
  if(!requireNamespace("chron", quietly = TRUE)) stop("This function will not work unless the `{chron}` package is installed")
  stopifnot(inherits(x, "POSIXct") || inherits(x, "POSIXlt") || inherits(x, "chron"))

  if(inherits(x, "chron")) x <- as.POSIXlt(x, tz = "GMT")

  chron::times(strftime(x, format = "%H:%M:%S", tz = tz))
}
