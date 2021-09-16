# https://purrr.tidyverse.org/reference/faq-adverbs-export.html
slow_query_api <- function(...) "dummy"
safe_query_api <- function(...) "dummy"

#' Get Data from Ofcom Mobile Coverage API
#'
#' "Subscribers can retrieve broadband coverage data against postcodes
#' up to 500 calls/minute for 150,000 requests per month." - Ofcom API docs
#'
#' @param postcode a UK postcode
#'
#' @return The API response (JSON format)
#' @export
query_api <- function(postcode) {

  # API key needs to be saved as environment variable OFCOM_API_KEY
  # There are other ways I could do this, but this will do for now
  key <- Sys.getenv("OFCOM_API_KEY")
  endpoint_base <- "https://api-proxy.ofcom.org.uk/mobile/coverage/"

  # remove any spaces or other non-alphanum characters from the input
  postcode <- stringr::str_remove_all(postcode, "[^[:alnum:]]")

  # turn above inputs into a query
  resp <- paste0(endpoint_base, postcode) %>%
    httr::GET(httr::add_headers(`Ocp-Apim-Subscription-Key` = key))

  httr::stop_for_status(resp)

  if (!httr::http_error(resp)) {
    httr::content(resp) %>% # JSON automatically converted to R list structure
      purrr::pluck("Availability") %>%
      purrr::map_df(dplyr::as_tibble) # pull coverage data into a tibble
  }
}
