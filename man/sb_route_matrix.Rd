% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{sb_route_matrix}
\alias{sb_route_matrix}
\title{Routing}
\usage{
sb_route_matrix(orig, dest, graph)
}
\arguments{
\item{orig}{sf, points of the origins.}

\item{dest}{sf, points of the destination.}

\item{graph}{dodgr routing graph, graph to route between the points.}
}
\value{
A data.table containing the summaries of the routed connections.
}
\description{
Routing
}
\examples{
print("tbd.")
}
