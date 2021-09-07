#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom magrittr %>%
## usethis namespace: end
NULL

# thanks Evan
# https://github.com/evanodell/dwpstat/blob/master/R/dwp-package.R

.onLoad <- function(libname, pkgname) {
  if (is.null(getOption("OFCOM.API.key"))) {
    key <- Sys.getenv("OFCOM_API_KEY")
    if (key != "") options("OFCOM.API.key" = key)
  }

  invisible()
}
