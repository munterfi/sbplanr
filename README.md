# Station-based sharing planner <img src="man/figures/logo.svg" align="right" alt="" width="120" />
<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build status](https://github.com/munterfinger/drtplanr/workflows/R-CMD-check/badge.svg)](https://github.com/munterfinger/drtplanr/actions)
[![pkgdown](https://github.com/munterfinger/drtplanr/workflows/pkgdown/badge.svg)](https://github.com/munterfinger/drtplanr/actions)
[![Codecov test coverage](https://codecov.io/gh/munterfinger/drtplanr/branch/master/graph/badge.svg)](https://codecov.io/gh/munterfinger/drtplanr?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/munterfinger/drtplanr/badge)](https://www.codefactor.io/repository/github/munterfinger/drtplanr)
<!-- badges: end -->

Tool for placing bicycle sharing stations by iteratively minimizing a global energy of a model that reflects the station-based bicycle sharing system. The station locations are randomly initialized in the street network and iteratively optimized based on the reachable population in combination with walking and driving times.

The model in the package example optimizes the positions of stations in an assumed bicycle sharing service for the municipality Bülach in Zurich, Switzerland.

|![](https://github.com/munterfinger/drtplanr/blob/feature/monamo/docs/example_i1000_energy_plot.png)|![](https://github.com/munterfinger/drtplanr/blob/feature/monamo/docs/example_i1000_station_map.png)|
|---|---|

## Getting started
Install the development version from [GitHub](https://github.com/munterfinger/drtplanr/) with:

``` r
remotes::install_github("munterfinger/drtplanr")
```

Create an example model:

``` r
# Example data
aoi <-
  sf::st_read(system.file("example.gpkg", package = "drtplanr"), layer = "aoi")

pop <-
  sf::st_read(system.file("example.gpkg", package = "drtplanr"), layer = "pop")

poi <-
  sf::st_read(system.file("example.gpkg", package = "drtplanr"), layer = "poi")[1,]

# Create model
m <- drt_drtm(
  model_name = "BÃ¼lach",
  aoi = aoi, pop = pop, poi = poi,
  n_sta = 15, m_seg = 100
)

# Iterate the model
m1 <- drt_iterate(m, 100)

# Visualize results
drt_plot(m)
drt_map(m)
```

## Structure of the model
### Input layers
The model is set up with the following inputs:

* **Spatial layer**:
  * Area of Interest (POLYGON)
  * Population raster centroids (POINT)
  * Point(s) of Interest (POINT)
* **Parameters**:
  * A model name
  * Distance in meters to segment the street network for candidate creation: default = 100m (The value is equivalent to the minimum possible distance between two stations on the street network).
  * Number of stations to place

### Global energy

Function that calculates the global energy of the current model state. The aim is to place the station in a way, that the residents and workers around them have to walk as short as possible to the station and that the station is connected as well as possible to other attractive stations in the network. An attractive station is a station with many people in the catchment area that can be quickly reached by bicycle.

$$Eg = \sum_{s_1 \neq s_2} \sum_{c \in S_1} \sum_{d \in S_2} P_c * P_d * (Wt_{c} + Bt_{s1s2} + Wt_d) $$

When the direct walking time between to populations is faster than the travel using the bicycle (walk to station, cycle, walk from station), than the direct walking travel is chosen.

### Optimization
The global energy of the model is optimized in iterations. In every iteration one station is randomly selected and moved to another position on the segmented street network. The global energy of the model state with the new candidate is calculated. If the global energy is lower as befor, the candidate is accepted and the next iteration starts. If the global energy is higher, the candidate is rejected with the probability $1-\alpha$. The probability $\alpha$ decreases exponentially as a function of the number of iterations ($i$):

$$f(i) = \frac{1}{(i + 1)}$$

The concept of sometimes allowing a bad candidate to be accepted is known as annealing. This technique prevents the optimization from being captured in a local minimum before the global minimum is reached.

## Authors
* Merlin Unterfinger (inital idea, package implementation) - [munterfinger](https://github.com/munterfinger)
* Thomas Hettinger (energy definition) - [thetti](https://github.com/thetti)
* David Masson (ideas and feedback on model optimization, annealing) - [panhypersebastos](https://github.com/panhypersebastos)

## References
* [hereR](https://github.com/munterfinger/hereR): R interface to the HERE REST APIs
* [BfS](https://www.bfs.admin.ch/): Population data for Switzerland
* [OSM](https://www.openstreetmap.org/): Street network data for routing purposes.

## Licence
* This repository is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.
