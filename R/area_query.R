poss_get_area_code <- function(...) "dummy"


#' Download postcodes from doogal.co.uk for a district/ltla or a county/utla
#'
#' @param area The name of a local authority district, unitary authority or county
#'   (England or Wales only).
#'
#' @return A data frame of postcodes and related information.
#' @export
#' @examples head(doogal_download("Isles of Scilly"))
doogal_download <- function(area) {

  area_code <- NULL

  # lookup ONS area code for the district
  area_code <- poss_get_area_code(area)
  if (length(area_code) == 1) {
    paste0("https://www.doogal.co.uk/AdministrativeAreasCSV.ashx?district=",
           area_code) %>%
      readr::read_csv(show_col_types = FALSE)
  } else {
    usethis::ui_stop("No postcode data was possible to retrieve for the area name provided.")
  }
}

# bit of a hack
get_area_code <- function(area) {
  jogger::geo_get("lad", area, "lad", return_boundaries = FALSE) %>%
    dplyr::pull(1)
}

#' Query Ofcom API for data from a sample of postcodes
#'
#' Convenience wrapper around `query_api` that includes a way to get a nice
#' tibble of results from an input df, with the option to easily retrieve
#' data for all  —  or a sample of  —  postcodes in a local authority area.
#'
#' @param area The name of a local authority area (lower or upper tier) in
#'   England or Wales. If `NULL`, then a data frame including a postcode variable
#'   should be supplied instead. If for some reason you supply both, this (`area`)
#'   will take priority over the `df` argument.
#'   `tapioca` samples by LSOA by default – supplying `prop = 1` to `...` will negate
#'   any effect of this, if sampling is undesired (`prop = 1` means all postcodes
#'   in the area will be included).
#' @param df User-supplied data frame containing a postcode variable.
#'   Default is `NULL`.
#' @param col The name of the postcode variable in `df`. Defaults to `postcode`.
#' @param sample_by A character vector. Name(s) of variable(s) in `df` to group data
#' by before sampling. Not required when using `area` (will just use LSOA).
#' @param return_errors Mainly for use as a debug mode. Defaults to `FALSE`, meaning
#'   the function will return a nice data frame of just successful results (errors
#'   removed). If you are not getting the results you expect, turn on
#'   `return_errors` and the function will instead return a list with
#'   components `result` and `error` for you to peruse.
#' @param ... Arguments to pass to `dplyr::slice_sample()`. Either `prop` =
#'   proportion or `n` = number. If empty, will submit just 1 postcode (1 per
#'   group, if grouped). Use with `sample_by` in order to group data before
#'   sampling (eg sample 20% of postcodes in each LSOA).
#'
#' @return Either a tibble of successful results from the API, or a list of results
#'   and errors (if `return_errors` is set to `TRUE`).
#' @export
area_query <- function(area = NULL, df = NULL, col = postcode, sample_by = NULL, return_errors = FALSE, ...) {

  col <- rlang::ensym(col) # allows arg to be supplied as a string

  if (is.null(area) && is.null(df)) {
    usethis::ui_stop("You must supply one of `area` or `df` as an argument.")
  }

  if (is.null(df)) {
    df <- area %>%
      purrr::map_df(doogal_download) %>%
      janitor::clean_names() %>%
      dplyr::filter(in_use == "Yes") %>%
      dplyr::select(postcode, lsoa11cd = "lsoa_code", lsoa11nm = "lsoa_name", easting:northing) %>%
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

  # returns
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
      dplyr::left_join(df, ., by = "postcode_sqsh") %>%
      dplyr::select(!postcode_sqsh)
  }
}
