% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_same_value_col.R
\name{find.same.value.col}
\alias{find.same.value.col}
\alias{unique_col}
\title{Find Columns Consisting of the Same Value in a Data Frame}
\usage{
find.same.value.col(data, col.name = c("number", "name"))

unique_col(data, fromLast = FALSE)
}
\arguments{
\item{data}{Data frame to check if there is a column consisting of the same value.}

\item{col.name}{Select whether the columns are represented by column names or by column numbers. The default value is the column number.}

\item{fromLast}{logical indicating if duplication should be considered from the reverse side.}
}
\value{
a list.
}
\description{
This function is used to find a column consisting of the same value in a data frame.
The answer will be returned in a list format, and those that have the same value in the column number or column name will be output.
\code{unique_col} is a function to remove duplicate columns in a data frame, the column version of \code{base}'s \code{\link[base]{unique}}.
}
