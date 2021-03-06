% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{sb_save_graphics}
\alias{sb_save_graphics}
\title{Save graphics of model}
\usage{
sb_save_graphics(obj, path)
}
\arguments{
\item{obj}{sbm, a sbm model.}

\item{path}{character, path to file.}
}
\value{
None.
}
\description{
Save graphics of model
}
\examples{
#' # Example model
m <- sb_import(
  system.file("example_i1000.RData", package = "sbplanr")
)

# Save to temp dir
# sb_save_graphics(m, path = tempdir())
}
