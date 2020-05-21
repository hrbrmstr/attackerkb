date_convert <- function(.x) {
  as.POSIXct(.x, format="%Y-%m-%dT%H:%M:%OS", tz="GMT")
}

.kb_reshape <- function(.x, path) {

  if (length(.x) == 0) return(data.frame(stringsAsFactors=FALSE))

  if (path == "/topics") {

    easy_cols <- .x[, c("id", "editorId", "name", "created", "revisionDate", "disclosureDate", "document")]

    easy_cols[["created"]] <- date_convert(easy_cols[["created"]])
    easy_cols[["revisionDate"]] <- date_convert(easy_cols[["revisionDate"]])

    easy_cols$references <- .x[["metadata"]][["references"]]

    cvss_v3 <- .x[["metadata"]][["baseMetricV3"]][["cvssV3"]]

    easy_cols$cvss_v3_scope <- cvss_v3[["scope"]]
    easy_cols$cvss_v3_version <- cvss_v3[["version"]]
    easy_cols$cvss_v3_baseScore <- cvss_v3[["baseScore"]]
    easy_cols$cvss_v3_attackVector <- cvss_v3[["attackVector"]]
    easy_cols$cvss_v3_baseSeverity <- cvss_v3[["baseSeverity"]]
    easy_cols$cvss_v3_vectorString <- cvss_v3[["vectorString"]]
    easy_cols$cvss_v3_integrityImpact <- cvss_v3[["integrityImpact"]]
    easy_cols$cvss_v3_userInteraction <- cvss_v3[["userInteraction"]]
    easy_cols$cvss_v3_attackComplexity <- cvss_v3[["attackComplexity"]]
    easy_cols$cvss_v3_availabilityImpact <- cvss_v3[["availabilityImpact"]]
    easy_cols$cvss_v3_privilegesRequired <- cvss_v3[["privilegesRequired"]]
    easy_cols$cvss_v3_confidentialityImpact <- cvss_v3[["confidentialityImpact"]]
    easy_cols$cvss_v3_impact <- .x[["metadata"]][["baseMetricV3"]][["impactScore"]]
    easy_cols$cvss_v3_exploitability <- .x[["metadata"]][["baseMetricV3"]][["exploitabilityScore"]]
    easy_cols$vulnerable_versions <- .x[["metadata"]][["vulnerable-versions"]]
    easy_cols$kb_attacker_value <- .x[["score"]][["attackerValue"]]
    easy_cols$kb_exploitability <- .x[["score"]][["exploitability"]]
    easy_cols$tag_commonEnterprise <- .x$tags[["commonEnterprise"]]
    easy_cols$tag_defaultConfiguration <- .x$tags[["defaultConfiguration"]]
    easy_cols$tag_difficultToPatch <- .x$tags[["difficultToPatch"]]
    easy_cols$tag_highPrivilegeAccess <- .x$tags[["highPrivilegeAccess"]]
    easy_cols$tag_easyToDevelop <- .x$tags[["easyToDevelop"]]
    easy_cols$tag_requiresInteraction <- .x$tags[["requiresInteraction"]]
    easy_cols$tag_obscureConfiguration <- .x$tags[["obscureConfiguration"]]
    easy_cols$tag_difficultToExploit <- .x$tags[["difficultToExploit"]]
    easy_cols$tag_noUsefulData <- .x$tags[["noUsefulData"]]
    easy_cols$tag_difficultToDevelop <- .x$tags[["difficultToDevelop"]]
    easy_cols$tag_preAuth <- .x$tags[["preAuth"]]
    easy_cols$tag_postAuth <- .x$tags[["postAuth"]]

    easy_cols

    rownames(easy_cols) <- NULL

    easy_cols

  } else if (path == "/topic") {

    ## List of 10
    ## $ created       : chr "2019-05-14T18:28:19.31074Z"
    ## $ disclosureDate: chr "2019-05-16T19:29:00Z"
    ## $ document      : chr "A bug in Windows Remote Desktop protocol allows unauthenticated users to run arbitrary code via a specially cra"| __truncated__
    ## $ editorId      : chr "7191a637-aa4e-4885-98a0-f4f2da285b99"
    ## $ id            : chr "131226a6-a1e9-48a1-a5d0-ac94baf8dfd2"
    ## $ metadata      :List of 16
    ## $ name          : chr "Windows Remote Desktop (RDP) Use-after-free vulnerablility, \"Bluekeep\""
    ## $ revisionDate  : chr "2020-03-03T16:18:02.56368Z"
    ## $ score         :List of 2
    ## $ tags          :List of 12

    .x[["created"]] <- date_convert(.x[["created"]])
    .x[["disclosed"]] <- date_convert(.x[["disclosureDate"]])
    .x[["metadata"]] <- I(list(.x[["metadata"]]))
    .x[["score"]] <- I(list(.x[["score"]]))
    .x[["tags"]] <- I(list(.x[["tags"]]))

    .x <- as.data.frame(.x, stringsAsFactors = FALSE)

    .x

  } else if (path == "/contributors") {

    .x[["created"]] <- date_convert(.x[["created"]])
    .x

  } else if (path == "/assessments") {

    easy_cols <- .x[,c("id", "editorId", "topicId", "created", "revisionDate", "document", "score")]

    easy_cols[["created"]] <- date_convert(easy_cols[["created"]])
    easy_cols[["revisionDate"]] <- date_convert(easy_cols[["revisionDate"]])

    metadata <- easy_cols[["metadata"]]

    easy_cols$tags <- metadata[["tags"]]
    easy_cols$attacker_value <- metadata[["attacker-value"]]
    easy_cols$exploitability <- metadata[["exploitability"]]
    easy_cols$stability <- metadata[["stability"]]
    easy_cols$reliability <- metadata[["reliability"]]
    easy_cols$urgent_to_patch <- metadata[["urgent-to-patch"]]
    easy_cols$used_successfully <- metadata[["used-successfully"]]
    easy_cols$mitigation_strength <- metadata[["mitigation-strength"]]
    easy_cols$confidence_in_ratings <- metadata[["confidence-in-ratings"]]
    easy_cols$effort_to_develop_exploit <- metadata[["effort-to-develop-exploit"]]
    easy_cols$versions <- metadata[["versions"]]
    easy_cols$mitigation <- metadata[["mitigation"]]
    easy_cols$forever_day_versions <- metadata[["forever_day_versions"]]
    easy_cols$offensive_application <- metadata[["offensive-application"]]
    easy_cols$atacker_utility <- metadata[["atacker-utility"]]
    easy_cols$urgent_topatch <- metadata[["urgent-to patch"]]

    easy_cols

  }

}

handle_response <- function(.x, api_key = attackerkb_api_key(), came_from = NULL) {

  .pb <- progress::progress_bar$new(format = "(:spin)", total = NA)
  .pb$tick()

  path <- .x[["links"]][["self"]][["href"]]
  if (length(path) == 0) path <- sub("^kb_", "/", came_from)

  ret <- .x[["data"]]

  ret <- .kb_reshape(ret, path)

  next_href <- .x[["links"]][["next"]][["href"]]

  while(length(next_href)) {

    .pb$tick()

    httr::GET(
      url = sprintf("https://api.attackerkb.com%s", next_href),
      .ATTACKERKB_UA,
      httr::add_headers(`Authorization` = sprintf("basic %s", api_key))
    ) -> res

    httr::stop_for_status(res)

    out <- httr::content(res, as = "text", encoding = "UTF-8")
    out <- jsonlite::fromJSON(out)

    next_href <- out[["links"]][["next"]][["href"]]

    ret <- data.table::rbindlist(list(ret, .kb_reshape(out[["data"]], path)), fill = TRUE)

  }

  class(ret) <- c("tbl_df", "tbl", "data.frame")
  ret

}
