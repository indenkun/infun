% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/handles_NA.R
\name{remove_na_rows}
\alias{remove_na_rows}
\alias{remove_na_cols}
\alias{consolidate_cols}
\alias{check_onevalue_cols}
\title{Handles data frames containing NA in a nice way.}
\usage{
remove_na_rows(data, cols, drop = FALSE)

remove_na_cols(data, cols)

consolidate_cols(data, cols)

check_onevalue_cols(data, cols)
}
\arguments{
\item{data}{data frame}

\item{cols}{You can specify the columns you wish to process by specifying the column names contained in the data frame.
If not specified, all columns of the data frame are processed.}

\item{drop}{relevant for matrices and arrays.  If \code{TRUE} the result is
    coerced to the lowest possible dimension (see the examples).  This
    only works for extracting elements, not for the replacement.  See
    \code{\link[base]{drop}} for further details.
  }
}
\description{
\code{remove_na_cols} deletes a column that consists only of \code{NA}. \code{remove_na_rows} deletes a rows that consists only of \code{NA}.
\code{consolidate_cols} retrieves a vector of values where each row of the specified data frame consists of NA and one other value, either with NA removed only or with NA if all values in the row are NA.
\code{check_onevalue_cols} is check funcion within \code{consolidate_cols}.
}
\examples{
d <- data.frame(value01 = c(1:3, NA),
                value02 = c(1:2, NA, NA),
                value03 = rep(NA, 4),
                value04 = c(1:3, NA),
                value05 = rep(NA, 4))
remove_na_cols(d)
remove_na_rows(d)

d <- data.frame(id_1 = c(1:3, rep(NA, 6)),
                id_2 = c(rep(NA, 3), 4:6, rep(NA, 3)),
                id_3 = c(rep(NA, 6), 7:9))
consolidate_cols(d)
check_onevalue_cols(d)
}
