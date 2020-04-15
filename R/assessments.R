#' Helpers to query AttackerKB assessments
#'
#' The main `kb_contributors` function maps 1:1 to the API. Leave values
#' `NULL` that you do not want included in the search parameters.
#'
#' @param assessment_id UUID of a specific assessment to return
#' @param editor_id  UUID of a contributor.
#' @param topid_id UUID of the topic this assessment was based on.
#' @param created Return all assessments that were created on the given date.
#' @param revised Return all assessments that were revised on the given date.
#' @param document Text to query the document attribute. A substring match is performed
#' @param metadata Text to query the metadata attribute. A substring match is performed
#' @param score Return all assessments with this score.
#' @param q Return all assessments that have content that match the query string.
#' @param api_key See [attackerkb_api_key()]
#' @references <https://api.attackerkb.com/api-docs/docs>
#' @export
kb_assessments <- function(assessment_id = NULL,
                           editor_id = NULL,
                           topid_id = NULL,
                           created = NULL,
                           revised = NULL,
                           document = NULL,
                           metadata = NULL,
                           score = NULL,
                           q = NULL,
                           api_key = attackerkb_api_key()) {

  assessment_id <- assessment_id[1]
  editor_id <- editor_id[1]
  topid_id <- topid_id[1]
  created <- created[1]
  revised <-revised[1]
  document <- document[1]
  metadata <- metadata[1]
  score <-score[1]
  q <- q[1]

  if (length(created)) created <- as.character(as.Date(created[1]))
  if (length(revised)) created <- as.character(as.Date(created[1]))

  httr::GET(
    url = "https://api.attackerkb.com/assessments",
    .ATTACKERKB_UA,
    query = list(
      id = assessment_id,
      editorId = editor_id,
      topicId = topid_id,
      created = created,
      revisionDate = revised,
      document = document,
      metadata = metadata,
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

#' @rdname kb_assessments
#' @export
kb_assessment <- function(assessment_id, api_key = attackerkb_api_key()) {

  assessment_id <- assessment_id[1]

  httr::GET(
    url = sprintf("https://api.attackerkb.com/assessments/%s", assessment_id),
    .ATTACKERKB_UA,
    httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
  ) -> res

  httr::stop_for_status(res)

  out <- httr::content(res, as = "text", encoding = "UTF-8")
  out <- jsonlite::fromJSON(out)

  out <- out$data

  metadata <- out$metadata
  out$metadata <- NULL

  out <- as.data.frame(out, stringsAsFactors = FALSE)

  out$tags <- list(metadata[["tags"]]) %l0% NA_character_
  out$attacker_value <- metadata[["attacker-value"]] %l0% NA_integer_
  out$exploitability <- metadata[["exploitability"]] %l0% NA_integer_
  out$stability <- metadata[["stability"]] %l0% NA_integer_
  out$reliability <- metadata[["reliability"]] %l0% NA_integer_
  out$urgent_to_patch <- metadata[["urgent-to-patch"]] %l0% NA_integer_
  out$used_successfully <- metadata[["used-successfully"]] %l0% NA_integer_
  out$mitigation_strength <- metadata[["mitigation-strength"]] %l0% NA_integer_
  out$confidence_in_ratings <- metadata[["confidence-in-ratings"]] %l0% NA_integer_
  out$effort_to_develop_exploit <- metadata[["effort-to-develop-exploit"]] %l0% NA_integer_
  out$versions <- list(metadata[["versions"]]) %||% list()
  out$mitigation <- metadata[["mitigation"]] %l0% NA_character_
  out$forever_day_versions <- list(metadata[["forever_day_versions"]]) %l0% list()
  out$offensive_application <- metadata[["offensive-application"]] %l0% NA_character_
  out$atacker_utility <- metadata[["atacker-utility"]] %l0% NA_integer_
  out$urgent_topatch <- metadata[["urgent-to patch"]] %l0% NA_integer_

  class(out) <- c("tbl_df", "tbl", "data.frame")

  out


}