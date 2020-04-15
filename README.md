
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Signed
by](https://img.shields.io/badge/Keybase-Verified-brightgreen.svg)](https://keybase.io/hrbrmstr)
![Signed commit
%](https://img.shields.io/badge/Signed_Commits-100%25-lightgrey.svg)
[![Linux build
Status](https://travis-ci.org/hrbrmstr/attackerkb.svg?branch=master)](https://travis-ci.org/hrbrmstr/attackerkb)  
![Minimal R
Version](https://img.shields.io/badge/R%3E%3D-3.2.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

# attackerkb

Tools to Query the Rapid7 AttackerKB API

## Description

Rapid7 manages a service — <https://attackerkb.com/> - where experts can
evaluate various aspects of emergent or existing vulnerabilities and the
community can query and retrieve results. Tools are provides to query
the AttackerKB API.

## What’s Inside The Tin

The following functions are implemented:

  - `attackerkb_api_key`: Get or set ATTACKERKB\_API\_KEY value
  - `kb_assessments`: Helpers to query AttackerKB assessments
  - `kb_contributors`: Helpers to query AttackerKB contributors
  - `kb_topics`: Helpers to query AttackerKB topics

## Installation

``` r
remotes::install_git("https://git.rud.is/hrbrmstr/attackerkb.git")
# or
remotes::install_git("https://git.sr.ht/~hrbrmstr/attackerkb")
# or
remotes::install_gitlab("hrbrmstr/attackerkb")
# or
remotes::install_bitbucket("hrbrmstr/attackerkb")
```

NOTE: To use the ‘remotes’ install options you will need to have the
[{remotes} package](https://github.com/r-lib/remotes) installed.

## Usage

``` r
library(attackerkb)

# current version
packageVersion("attackerkb")
## [1] '0.1.0'
```

## attackerkb Metrics

| Lang | \# Files | (%) | LoC |  (%) | Blank lines |  (%) | \# Lines |  (%) |
| :--- | -------: | --: | --: | ---: | ----------: | ---: | -------: | ---: |
| R    |        9 | 0.9 | 302 | 0.97 |          96 | 0.86 |      288 | 0.91 |
| Rmd  |        1 | 0.1 |   8 | 0.03 |          15 | 0.14 |       28 | 0.09 |

## Code of Conduct

Please note that this project is released with a Contributor Code of
Conduct. By participating in this project you agree to abide by its
terms.
