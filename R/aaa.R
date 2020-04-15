set_names <- function (object = nm, nm) { names(object) <- nm ; object }

httr::user_agent(
  sprintf(
    "{attackerkb} package v%s: (<%s>)",
    utils::packageVersion("attackerkb"),
    utils::packageDescription("attackerkb")$URL
  )
) -> .ATTACKERKB_UA
