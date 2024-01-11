test_that("root data returns sensible, validated, data", {
  ## Just hello world for the package really
  endpoint <- littlestar_endpoint("GET", "/", NULL)
  res <- endpoint$run()
  expect_true(res$validated)
  expect_true(all(c("littlestar") %in%
                  names(res$data)))
  expect_match(unlist(res$data), "^[0-9]+\\.[0-9]+\\.[0-9]+$")
})


test_that("Can construct the api", {
  path_apps <- withr::local_tempdir()
  path_data <- withr::local_tempdir()
  obj <- api(path_apps, path_data)
  result <- evaluate_promise(value <- obj$request("GET", "/")$status)
  expect_equal(value, 200)
  logs <- lapply(strsplit(result$output, "\n")[[1]], jsonlite::parse_json)
  expect_length(logs, 2)
  expect_equal(logs[[1]]$logger, "littlestar")
})
