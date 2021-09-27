test_that("sbm works", {
  # Example data
  poi <-
    sf::st_read(system.file("example.gpkg", package = "sbplanr"),
                layer = "poi", quiet = TRUE)[1, ]
  aoi <-
    sf::st_read(system.file("example.gpkg", package = "sbplanr"),
                layer = "aoi", quiet = TRUE)
  pop <-
    sf::st_read(system.file("example.gpkg", package = "sbplanr"),
                layer = "pop", quiet = TRUE)

  # Create model
  m <- sb_sbm(
    model_name = "example",
    aoi = aoi, poi = poi, pop = pop,
    n_sta = 15, m_seg = 100
  )
  m
  sb_summary(m)

  # Test sbm class
  expect_is(m, "sbm")
  expect_equal(length(m), 9)

  # Iterate model with precalculation
  i = 3
  m_tt <- sb_iterate(m, i, precalculate = TRUE, annealing = TRUE)
  m_tf <- sb_iterate(m, i, precalculate = TRUE, annealing = FALSE)

  # Iterate model without precalculation
  m_ft <- sb_iterate(m, i, precalculate = FALSE, annealing = TRUE)
  m_ff <- sb_iterate(m, i, precalculate = FALSE, annealing = FALSE)

  # Test iterations
  expect_equal(m_tt$i, i)
  expect_equal(m_tf$i, i)
  expect_equal(m_ft$i, i)
  expect_equal(m_ff$i, i)

})
