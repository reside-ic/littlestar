##' Create littlestar api
##'
##' @title Create littlestar api
##'
##' @param path_apps Path to the app directory root
##'
##' @param path_data Path to the location we will store our internal
##'   data (outside of the app tree)
##'
##' @param validate Logical, indicating if validation should be done
##'   on responses.  This should be `FALSE` in production
##'   environments.  See [porcelain::porcelain] for details
##'
##' @param log_level Logging level to use. Sensible options are "off",
##'   "info" and "all".
##'
##' @return A [porcelain::porcelain] object. Notably this does *not*
##'   start the server
##'
##' @export
##' @importFrom lgr lgr
api <- function(path_apps, path_data, validate = NULL, log_level = "info") {
  state <- list(path = list(apps = path_apps,
                            internal = path_data))
  logger <- porcelain::porcelain_logger(log_level)
  api <- porcelain::porcelain$new(validate = validate, logger = logger)
  api$include_package_endpoints(state = state)
}


##' @porcelain GET / => json(root)
root <- function() {
  versions <- list(littlestar = package_version_string("littlestar"))
  lapply(versions, scalar)
}
