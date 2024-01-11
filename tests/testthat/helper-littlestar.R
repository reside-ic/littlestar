littlestar_endpoint <- function(method, path, root, validate = TRUE) {
  porcelain::porcelain_package_endpoint("littlestar", method, path,
                                        state = list(root = root),
                                        validate = validate)
}
