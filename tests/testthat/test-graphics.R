test_that("graphics works", {

  # Load file
  m <- sb_import(
    system.file("example_i1000.RData", package = "sbplanr")
  )

  # Test energy plot
  expect_is(sb_plot(m), "ggplot")

  # Test station map
  expect_is(sb_map(m), "mapview")

})
