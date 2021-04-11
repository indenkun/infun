#' Outputs the Table Created by the gtsummary package in Various File Formats.
#'
#' @description
#' This function is used to output the table created by the gtsummary package in PowerPoint or Word, or as an image file.
#' It just wraps \code{gtsummary}'s \code{\link[gtsummary]{as_flex_table}} and \code{flextalbe}'s \code{save_as*} functions.
#'
#' @param x gtsummary table object.
#' @param values a list (possibly named), each element is a flextable object. If named objects, names are used as slide titles.
#' @param path PowerPoint or Word or Image file to be created. It should end with filename extensions. Supported filename extensions: .pptx, .docx, .png, .pdf, .jpg.
#' @param pr_section a \code{\link[officer]{prop_section}} object that can be used to define page layout such as orientation, width and height.
#' @param zoom parameters used by \code{webshot} function.
#' @param expand parameters used by \code{webshot} function.
#' @param webshot webshot package as a scalar character, one of "webshot" or "webshot2".
#'
#' @details
#' The \code{\link[gtsummary]{as_flex_table}} argument of \code{gtsummary} is the default, so if you want to fine-tune it, you can do it yourself.
#'
#' @export

save_gtsummary <- function(x, path, values = NULL, pr_section = NULL, zoom = 3, expand = 10, webshot = "webshot"){
  if(!requireNamespace("gtsummary", quietly = TRUE)) stop("This function will not work unless the `{gtsummary}` package is installed")
  if(!requireNamespace("flextable", quietly = TRUE)) stop("This function will not work unless the `{flextable}` package is installed")
  if(!requireNamespace("tools", quietly = TRUE)) stop("This function will not work unless the `{tools}` package is installed")

  extension_types <- c("docx", "pptx", "png", "pdf", "jpg")

  file_type <- tools::file_ext(path)

  if(!(file_type %in% extension_types)){
    msg <- paste("The output must be a valid file path with one of these estensions:", paste(extension_types, collapse = ","))
    stop(msg)
  }

  x <- gtsummary::as_flex_table(x = x)

  if(file_type == "pptx") flextable::save_as_pptx(x, values = values, path = path)
  else if(file_type == "docx") flextable::save_as_docx(x, values = values, path = path, pr_section = pr_section)
  else if(file_type %in% c("png", "pdf", "jpg")) flextable::save_as_image(x = x, path = path, zoom = zoom, expand = expand, webshot = webshot)
}
