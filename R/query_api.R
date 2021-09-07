#' Get Data from Ofcom Mobile Coverage API
#'
#' "Subscribers can retrieve broadband coverage data against postcodes
#' up to 500 calls/minute for 150,000 requests per month."
#'
#' @param postcode a postcode
#'
#' @return The API response (JSON format)
#' @export
query_api <- function(postcode) {

  # API key needs to be saved as an environment variable
  key <- Sys.getenv("OFCOM_API_KEY")
  endpoint_base <- "https://api-proxy.ofcom.org.uk/mobile/coverage/"

  # remove any spaces or other non-alphanum characters from the input
  postcode <- stringr::str_remove_all(postcode, "[^[:alnum:]]")

  resp <- paste0(endpoint_base, postcode) %>%
    httr::GET(httr::add_headers(`Ocp-Apim-Subscription-Key` = key))

  httr::stop_for_status(resp, "query API endpoint")

  if (!httr::http_error(resp)) {
    httr::content(resp) %>% # JSON automatically converted to R list structure
      purrr::pluck("Availability") %>%
      purrr::map_df(dplyr::as_tibble)
  }
}


