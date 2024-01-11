test_that("Can parse arguments", {
  expect_mapequal(
    parse_cli_args(c("path_apps", "path_data")),
    list(log_level = "info",
         validate = FALSE,
         port = 8001,
         path_apps = "path_apps",
         path_data = "path_data"))
  expect_mapequal(
    parse_cli_args(c("--port=8080", "path_apps", "path_data")),
    list(log_level = "info",
         validate = FALSE,
         port = 8080,
         path_apps = "path_apps",
         path_data = "path_data"))
  expect_mapequal(
    parse_cli_args(c("--port=8080", "--validate", "path_apps", "path_data")),
    list(log_level = "info",
         validate = TRUE,
         port = 8080,
         path_apps = "path_apps",
         path_data = "path_data"))
  expect_mapequal(
    parse_cli_args(c("--log-level=debug", "--validate", "path_apps",
                     "path_data")),
    list(log_level = "debug",
         validate = TRUE,
         port = 8001,
         path_apps = "path_apps",
         path_data = "path_data"))
})


test_that("Can construct api", {
  skip_if_not_installed("mockery")
  mock_run <- mockery::mock()
  mock_api <- mockery::mock(list(run = mock_run))
  mockery::stub(cli, "api", mock_api)
  cli(c("--log-level=debug", "path_apps", "path_data"))

  mockery::expect_called(mock_api, 1)
  expect_equal(mockery::mock_args(mock_api)[[1]],
               list("path_apps", "path_data", FALSE, "debug"))

  mockery::expect_called(mock_run, 1)
  expect_equal(mockery::mock_args(mock_run)[[1]], list("0.0.0.0", port = 8001))
})
