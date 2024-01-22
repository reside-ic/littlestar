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
api <- function(path_apps, path_data, queue_id = "littlestar",
                validate = NULL, log_level = "info") {
  state <- list(path_apps = path_apps,
                path_data = path_data,
                rrq = rrq::rrq_controller$new(queue_id))
  logger <- porcelain::porcelain_logger(log_level)
  api <- porcelain::porcelain$new(validate = validate, logger = logger)
  api$include_package_endpoints(state = state)
}


##' @porcelain GET / => json(root)
root <- function() {
  versions <- list(littlestar = package_version_string("littlestar"))
  lapply(versions, scalar)
}


##' @porcelain POST /git/clone/submit/<app:str> => json
##'   path_apps state :: path_apps
##'   rrq state :: rrq
git_update_submit <- function(path_apps, rrq, app) {
  rrq$enqueue(gert::git_clone(url, path = file.path(path_apps, app)))
}


## Right, the question here is do we provide general information about
## any queued job from the same code?  How do we get the logs out?
## What does rrq provide to make this easy?


##' @porcelain POST /git/update/submit/<app:str> => json
##'   path_apps state :: path_apps
##'   rrq state :: rrq
git_update_submit <- function(path_apps, rrq, app) {
  rrq$enqueue(gert::git_fetch(repo = file.path(path_apps, app)))
}


##' @porcelain GET /git/update/status/<id:str> => json(git-update-submit)
##'   state state :: state
git_queue__status <- function(rrq, id) {
  rrq$task_status(id)
}


git_queue_result <- function(rrq, id) {
  rrq$task_result(id)
}


##' @porcelain GET /git/refs/<app:str> => json(git-list-refs)
##'   path_apps state :: path_apps
git_list_refs <- function(path_apps, rrq, app) {
  path <- file.path(root, "apps", app)
  to_json(do_git_list_refs(path))
}


##' @porcelain POST /git/checkout/<app:str>/<ref:str> => json(git-checkout)
##'   state state :: state
##'   query type :: string
git_checkout <- function(path_apps, app, ref) {
  path <- file.path(path_apps, "apps", app)
  do_git_checkout(path, ref, type)
}
