.kb_reshape <- function(.x, path) {

  if (path == "/topics") {

    easy_cols <- .x[, c("id", "editorId", "name", "created", "revisionDate", "disclosureDate", "document")]

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

  } else if (path == "/contributors") {

    .x

  } else if (path == "/assessments") {

    easy_cols <- .x[,c("id", "editorId", "topicId", "created", "revisionDate", "document", "score")]

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

handle_response <- function(.x, api_key = attackerkb_api_key()) {

  path <- .x[["links"]][["self"]][["href"]]

  ret <- .x[["data"]]

  ret <- .kb_reshape(ret, path)

  next_href <- .x[["links"]][["next"]][["href"]]

  while(length(next_href)) {

    cat(".")

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

  cat("\n")

  class(ret) <- c("tbl_df", "tbl", "data.frame")
  ret

}
