#' Tools to Query the Rapid7 AttackerKB API
#'
#' Rapid7 manages a service — <https://attackerkb.com/> - where experts can evaluate
#' various aspects of emergent or existing vulnerabilities and the community can query and
#' retrieve results. Tools are provided to query the AttackerKB API.
#'
#' For all API calls, set the option `progress_enabled` to `FALSE` to disable
#' progress spinner.
#'
#' @md
#' @name attackerkb
#' @keywords internal
#' @author Bob Rudis (bob@@rud.is)
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom data.table rbindlist
#' @importFrom progress progress_bar
"_PACKAGE"
