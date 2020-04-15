#' Helpers to query AttackerKB contributors
#'
#' The main `kb_contributors` function maps 1:1 to the API. Leave values
#' `NULL` that you do not want included in the search parameters.
#'
#' @param contributor_id UUID of a specific contributror to return
#' @param username Return contributors with the matching username.
#' @param avatar Return all contributors where avatar matches the given value
#' @param created Return all contributors that were created on the given date.
#' @param score Return all contributors with this score.
#' @param q Return all contributors that have usernames that match the query string.
#' @param api_key See [attackerkb_api_key()]
#' @references <https://api.attackerkb.com/api-docs/docs>
#' @export
kb_contributors <- function(contributor_id = NULL,
                            username = NULL,
                            avatar = NULL,
                            created = NULL,
                            score = NULL,
                            q = NULL,
                            api_key = attackerkb_api_key()) {

  contributor_id <- contributor_id[1]
  username <- username[1]
  avatar <- avatar[1]
  created <- created[1]
  score <- score[1]
  q <- q[1]

  if (length(created)) created <- as.character(as.Date(created[1]))

  httr::GET(
    url = "https://api.attackerkb.com/contributors",
    .ATTACKERKB_UA,
    query = list(
      id = contributor_id,
      username = username,
      avatar = avatar,
      created = created,
      score = score,
      q = q,
      size = 500L
    ),
    httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  out <- handle_response(out)

  out

}

#' @rdname kb_contributors
#' @export
kd_contributor <- function(contributor_id, api_key = attackerkb_api_key()) {

  contributor_id <- contributor_id[1]

  httr::GET(
    url = sprintf("https://api.attackerkb.com/contributors/%s", contributor_id),
    .ATTACKERKB_UA,
    httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  out <- as.data.frame(out$data, stringsAsFactors=FALSE)

  class(out) <- c("tbl_df", "tbl", "data.frame")
  out


}