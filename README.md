<!-- README.md is generated from README.Rmd. Please edit that file -->
ForecastMoments
===============

The joint forecast observation distribution for Gaussian variables can be described with 6 low-order moments. 'ForecastMoments' provides functions to compute these moments, and to interpret forecast quality using a signal-plus-noise model based on these low-order moments. Uncertainty assessment of these moments and derived forecast quality information including traditional verification scores and skill scores is provided based on parametric bootstrap resampling.

Installation
------------

The package can be installed from github.

``` r
library(devtools)
install_github("jonasbhend/ForecastMoments")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
library(ForecastMoments)
#> Loading required package: easyVerification
#> Loading required package: SpecsVerification
#> 
#> Attaching package: 'easyVerification'
#> The following object is masked from 'package:SpecsVerification':
#> 
#>     EnsCorr

tm <- easyVerification::toymodel()
summary(SNRresample(tm$fcst, tm$obs, c("EnsCorr", "FairCrpss")))
#>                               orig  boot_mean    boot_sd boot_p0.025
#> EnsCorr                 0.43958856 0.42036284 0.16645772  0.05785797
#> FairCrpss.skillscore    0.05768686 0.01097965 0.12288816 -0.24315200
#> FairCrpss.skillscore.sd 0.11107607 0.12328414 0.03179172  0.07464745
#>                         boot_p0.975
#> EnsCorr                   0.7013449
#> FairCrpss.skillscore      0.2233812
#> FairCrpss.skillscore.sd   0.1948931
```
