#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom magrittr %>%
## usethis namespace: end
NULL

# https://purrr.tidyverse.org/reference/faq-adverbs-export.html
.onLoad <- function(libname, pkgname) {
  # rate of 0.125 is based on API limit of 500 requests/minute
  # (ie rate needs to be a bit slower than one request every 0.12s)
  slow_query_api <<- purrr::slowly(query_api, rate = purrr::rate_delay(pause = 0.125))
  safe_query_api <<- purrr::safely(slow_query_api, otherwise = NULL)

  invisible()
}
