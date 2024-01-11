parse_cli_args <- function(args = commandArgs(TRUE)) {
  usage <- "Usage:
littlestar [options] <path-apps> <path-data>

Options:
  --log-level=LEVEL  Log-level (off, info, all) [default: info]
  --validate         Enable json schema validation
  --port=PORT        Port to run api on [default: 8001]"
  dat <- docopt::docopt(usage, args)
  list(path_apps = dat$path_apps,
       path_data = dat$path_data,
       log_level = dat$log_level,
       validate = dat$validate,
       port = as.integer(dat$port))
}


cli <- function(args = commandArgs(TRUE)) {
  dat <- parse_cli_args(args)
  obj <- api(dat$path_apps, dat$path_data, dat$validate, dat$log_level)
  obj$run("0.0.0.0", port = dat$port)
}
