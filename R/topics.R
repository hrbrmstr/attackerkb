#' Helpers to query AttackerKB topics
#'
#' The main `kb_topics` function maps 1:1 to the API. Leave values
#' `NULL` that you do not want included in the search parameters.
#'
#' @param topic_id UUID of a specific topic to return
#' @param editor_id UUID of a contributor
#' @param name Text to query the name attribute. A substring match is performed
#' @param created Return all topics that were created on the given date.
#' @param revised Return all topics that were revised on the given date.
#' @param disclosed Return all topics that were disclosed on the given date.
#' @param document Text to query the document attribute. A substring match is performed
#' @param metadata Text to query the metadata attribute. A substring match is performed
#' @param featured (lgl) `TRUE`/`FALSE`. Return all topics that are featured.
#' @param q Return all topics that have content that matches the query string.
#' @param api_key See [attackerkb_api_key()]
#' @references <https://api.attackerkb.com/api-docs/docs>
#' @export
kb_topics <- function(topic_id = NULL,
                      editor_id = NULL,
                      name = NULL,
                      created = NULL,
                      revised = NULL,
                      disclosed = NULL,
                      document = NULL,
                      metadata = NULL,
                      featured = NULL,
                      q = NULL,
                      api_key = attackerkb_api_key()) {

  topic_id <- topic_id[1]
  editor_id <-editor_id[1]
  name <- name[1]
  created <- created[1]
  revised <-revised[1]
  disclosed <- disclosed[1]
  document <- document[1]
  metadata <- metadata[1]
  featured <- featured[1]
  q <- q[1]

  if (length(featured)) featured <- tolower(as.character(as.logical(featured)))
  if (length(created)) created <- as.character(as.Date(created[1]))
  if (length(revised)) revised <- as.character(as.Date(revised[1]))
  if (length(disclosed)) disclosed <- as.character(as.Date(disclosed[1]))

  httr::GET(
    url = "https://api.attackerkb.com/topics",
    .ATTACKERKB_UA,
    query = list(
      id = topic_id,
      editorId = editor_id,
      name = name,
      created = created,
      revisionDate = revised,
      disclosureDate = disclosed,
      document = document,
      metadata = metadata,
      featured = featured,
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

#' @rdname kb_topics
#' @export
kb_topic <- function(topic_id = "131226a6-a1e9-48a1-a5d0-ac94baf8dfd2", api_key = attackerkb_api_key()) {

  httr::GET(
    url = sprintf("https://api.attackerkb.com/topics/%s", topic_id[1]),
    .ATTACKERKB_UA,
    httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  out <- handle_response(out)

  out

}
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_contributor <- function(editor_id = "7191a637-aa4e-4885-98a0-f4f2da285b99", api_key = attackerkb_api_key()) {
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       editorId = editor_id[1],
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_name <- function(q = "bluekeep", api_key = attackerkb_api_key()) {
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       name = q[1],
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_document <- function(q = "bluekeep", api_key = attackerkb_api_key()) {
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       document = q[1],
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_content <- function(q = "bluekeep", api_key = attackerkb_api_key()) {
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       content = q[1],
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_metadata <- function(lookup = "bluekeep", api_key = attackerkb_api_key()) {
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       metadata = lookup[1],
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_date_created_date <- function(created = "2019-07-04", api_key = attackerkb_api_key()) {
#
#   created <- as.Date(created[1])
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       created = as.character(created[1]),
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_date_revised_date <- function(revised = "2019-07-04", api_key = attackerkb_api_key()) {
#
#   revised <- as.Date(revised[1])
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       revisionDate = as.character(revised[1]),
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
# #' @rdname kb_topics
# #' @export
# kb_topics_by_date_disclosed_date <- function(disclosed = "2019-07-04", api_key = attackerkb_api_key()) {
#
#   disclosed <- as.Date(disclosed[1])
#
#   httr::GET(
#     url = "https://api.attackerkb.com/topics",
#     .ATTACKERKB_UA,
#     query = list(
#       disclosureDate = as.character(disclosed[1]),
#       size = 500L
#     ),
#     httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
#   ) -> res
#
#   httr::stop_for_status(res)
#
#   out <- httr::content(res, as = "text", encoding = "UTF-8")
#   out <- jsonlite::fromJSON(out)
#
#   out <- handle_response(out)
#
#   out
#
# }
#
