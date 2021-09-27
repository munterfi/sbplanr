#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    sprintf(
      "sbplanr %s: Experimental station-based bicycle sharing planner",
      utils::packageVersion("sbplanr")
    )
  )
}

#' Message with timestamp
#'
#' @param text character, test of the message
#'
#' @return
#' None.
#'
#' @export
#'
#' @examples
#' tmessage("Test")
tmessage <- function(text) {
  message(Sys.time(), " ", text)
}
