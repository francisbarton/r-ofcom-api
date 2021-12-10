# tapioca 0.0.6 (10 December 2021)

* Added `.data` pronouns to functions in `area_query.R` and now get NO NOTES on R CMD check!!

# tapioca 0.0.5 (7 December 2021)

* Removed Counties API functionality as it doesn't return LSOA details like the Admin Areas API. And instead...:
* Added the ability for `area_query` to handle a vector of area names via `purrr::map_df`, so you can send all LAD names from a county in one go

# tapioca 0.0.4 (7 December 2021)

* Introduced `possibly` adverb for `doogal_download` and when properly documented, fixes issue #5.

# tapioca 0.0.3 (7 December 2021)

* Added a `NEWS.md` file to track changes to the package.
* Added Counties API (doogal.co.uk) for retrieval of postcodes in `doogal_download.R` (addresses #1)
* Improved some function param documentation
