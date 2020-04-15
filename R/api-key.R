#' Get or set ATTACKERKB_API_KEY value
#'
#' The API wrapper functions in this package all rely on a AttackerKB API
#' key residing in the environment variable `ATTACKERKB_API_KEY`.
#' The easiest way to accomplish this is to set it
#' in the `.Renviron` file in your home directory.
#'
#' You can obtain an AttackerKB API key by going visiting
#' **AttackerKB Profile Page > Settings > API Key.**
#'
#' @md
#' @param force Force setting a new AttackerKB key for the current environment?
#' @return atomic character vector containing the AttackerKB API key
#' @export
attackerkb_api_key <- function(force = FALSE) {

  env <- Sys.getenv('ATTACKERKB_API_KEY')
  if (!identical(env, "") && !force) return(env)

  if (!interactive()) {
    stop("Please set env var ATTACKERKB_API_KEY to your AttackerKB key",
         call. = FALSE)
  }

  message("Couldn't find env var ATTACKERKB_API_KEY See ?attackerkb_api_key for more details.")
  message("Please enter your API key:")
  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("AttackerKB key entry failed", call. = FALSE)
  }

  message("Updating ATTACKERKB_API_KEY env var")
  Sys.setenv(ATTACKERKB_API_KEY = pat)

  pat

}
