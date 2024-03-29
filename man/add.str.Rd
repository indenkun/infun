% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_str.R
\name{add.str}
\alias{add.str}
\title{Combine All the Items in a Specific Column of a Data Frame with any String of Characters}
\usage{
add.str(data, key, add.string = "ALL")
}
\arguments{
\item{data}{Specify the data frame to be converted. No other data frame is accepted.}

\item{key}{Specify the name of the column where you want to convert the value to ALL, etc. and combine them. If the column name does not exist in the data frame, an error occurs.}

\item{add.string}{Specifies an any single string or value. Convert the specified column to any string of characters or value. The default value is ALL.}
}
\value{
a data frame.
}
\description{
Combine all the items in a specific column of a data frame with any string of characters in the original data frame.
Only data frames are supported.
The converted column will be a string because it contains strings such as ALL.
}
