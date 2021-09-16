
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tapioca

<!-- badges: start -->
<!-- badges: end -->

### Tap into the Ofcom Mobile API

This package facilitates querying the Ofcom Mobile API.

![some tapioca](tapioca_image.jpg)

### Installation:

``` r
remotes::install_github("francisbarton/tapioca")
```

### Example:

``` r
library(tapioca)
pillar::glimpse(head(query_api("SE1 9HA")))
#> Rows: 6
#> Columns: 35
#> $ UPRN                    <dbl> 10091958681, 10090749078, 10013532193, 1001353~
#> $ AddressShortDescription <chr> "L S TELCOM UK LTD, RIVERSIDE HOUSE, 2A, SOUTH~
#> $ PostCode                <chr> "SE19HA", "SE19HA", "SE19HA", "SE19HA", "SE19H~
#> $ EEVoiceOutdoor          <int> 3, 3, 3, 3, 3, 3
#> $ EEVoiceOutdoorNo4g      <int> 3, 3, 3, 3, 3, 3
#> $ EEVoiceIndoor           <int> 3, 3, 3, 3, 3, 3
#> $ EEVoiceIndoorNo4g       <int> 3, 3, 3, 3, 3, 3
#> $ EEDataOutdoor           <int> 4, 4, 4, 4, 4, 4
#> $ EEDataOutdoorNo4g       <int> 3, 3, 3, 3, 3, 3
#> $ EEDataIndoor            <int> 4, 4, 4, 4, 4, 4
#> $ EEDataIndoorNo4g        <int> 3, 3, 3, 3, 3, 3
#> $ H3VoiceOutdoor          <int> 3, 3, 3, 3, 3, 3
#> $ H3VoiceOutdoorNo4g      <int> 3, 3, 3, 3, 3, 3
#> $ H3VoiceIndoor           <int> 4, 4, 4, 4, 4, 4
#> $ H3VoiceIndoorNo4g       <int> 4, 4, 4, 4, 4, 4
#> $ H3DataOutdoor           <int> 4, 4, 4, 4, 4, 4
#> $ H3DataOutdoorNo4g       <int> 3, 3, 3, 3, 3, 3
#> $ H3DataIndoor            <int> 4, 4, 4, 4, 4, 4
#> $ H3DataIndoorNo4g        <int> 4, 4, 4, 4, 4, 4
#> $ TFVoiceOutdoor          <int> 3, 3, 3, 3, 3, 3
#> $ TFVoiceOutdoorNo4g      <int> 3, 3, 3, 3, 3, 3
#> $ TFVoiceIndoor           <int> 4, 4, 4, 4, 4, 4
#> $ TFVoiceIndoorNo4g       <int> 4, 4, 4, 4, 4, 4
#> $ TFDataOutdoor           <int> 4, 4, 4, 4, 4, 4
#> $ TFDataOutdoorNo4g       <int> 3, 3, 3, 3, 3, 3
#> $ TFDataIndoor            <int> 4, 4, 4, 4, 4, 4
#> $ TFDataIndoorNo4g        <int> 4, 4, 4, 4, 4, 4
#> $ VOVoiceOutdoor          <int> 3, 3, 3, 3, 3, 3
#> $ VOVoiceOutdoorNo4g      <int> 3, 3, 3, 3, 3, 3
#> $ VOVoiceIndoor           <int> 4, 4, 4, 4, 4, 4
#> $ VOVoiceIndoorNo4g       <int> 4, 4, 4, 4, 4, 4
#> $ VODataOutdoor           <int> 4, 4, 4, 4, 4, 4
#> $ VODataOutdoorNo4g       <int> 3, 3, 3, 3, 3, 3
#> $ VODataIndoor            <int> 4, 4, 4, 4, 4, 4
#> $ VODataIndoorNo4g        <int> 4, 4, 4, 4, 4, 4
```
