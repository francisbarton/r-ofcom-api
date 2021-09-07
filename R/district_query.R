#' Download postcodes from doogal.co.uk for a district
#'
#' TODO possibly enable querying the Counties API etc as well.
#'
#' @param district name of a local authority district (lower tier only)
#' (England or Wales only)
#'
#' @return a data frame of postcodes and related information
#' @export
#' @examples head(doogal_download("Isles of Scilly"))
doogal_download <- function(district) {

  # lookup ONS area code for the district
  district_code <- jogger::geo_get("lad", district, "lad", return_boundaries = FALSE) %>%
    dplyr::pull(1)

  paste0("https://www.doogal.co.uk/AdministrativeAreasCSV.ashx?district=",
         district_code) %>%
    readr::read_csv()
}


#' Query Ofcom API for a sample of postcodes from a df or for a district
#'
#' Convenience wrapper around `query_api` that includes a way to get a nice
#' tibble of results from an input df, with the option to easily retrieve
#' data for all, or a sample of, postcodes in a local authority district.
#'
#' @param district name of a local authority district in England or Wales. If NULL then a data frame including a postcode variable should be supplied instead. Will take priority over the df argument. Automatically samples by LSOA (supplying `prop = 1` to `...` will negate any effect of this, if undesired).
#' @param df default NULL. User-supplied data frame containing a postcode variable
#' @param col name of the postcode variable in the df. Defaults to "postcode"
#' @param sample_by character vector. Names of variables to group data by before sampling
#' @param return_errors mainly used as a debug mode. Defaults to FALSE, meaning the function will return a nice data frame of successful results. If you are not getting the results you expect, turn on return_errors and the function will instead return a list with results and errors
#' @param ... arguments to pass to dplyr::slice_sample(). Either prop = proportion or n = number. If empty, will submit just 1 postcode (1 per group, if grouped). Use with sample_by in order to group data before sampling (eg sample 20% of postcodes in each LSOA)
#'
#' @return either a tibble of successful results from the API, or a list of results and errors (if return_errors is set to TRUE)
#' @export
district_query <- function(district = NULL, df = NULL, col = postcode, sample_by = NULL, return_errors = FALSE, ...) {

  col <- rlang::ensym(col) # allows arg to be supplied as a string

  if (is.null(district) && is.null(df)) {
    usethis::ui_stop("You must supply one of `district` or `df` as an argument.")
  }

  if (is.null(df)) {
    df <- doogal_download(district) %>%
      janitor::clean_names() %>%
      dplyr::filter(in_use == "Yes") %>%
      dplyr::select(postcode, lsoa11cd = lsoa_code, lsoa11nm = lsoa_name, easting:northing) %>%
      dplyr::group_by(lsoa11cd, lsoa11nm) %>%
      dplyr::slice_sample(...) %>%
      dplyr::ungroup()
  } else if (!is.null(sample_by)) {
    df <- df %>%
      dplyr::group_by(across(sample_by)) %>%
      dplyr::slice_sample(...) %>%
      dplyr::ungroup()
  } else {
    df <- df %>%
      dplyr::slice_sample(...) # last resort
  }

  df <- df %>%
    dplyr::mutate(postcode_sqsh = stringr::str_remove_all({{col}}, "[^[:alnum:]]"))

  results <- df %>%
    dplyr::pull(col) %>%
    purrr::map(safe_query_api)

  if (return_errors) {
    results
  } else {
    results %>%
      purrr::map("result") %>%
      purrr::compact() %>% # remove NULLs
      purrr::reduce(dplyr::bind_rows) %>% # combine to single tibble
      dplyr::rename(
        postcode_sqsh = PostCode
      ) %>%
      dplyr::left_join(df, .) %>%
      dplyr::select(!postcode_sqsh)
  }
}
