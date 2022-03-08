# Station-based bicycle sharing planner <img src="man/figures/logo.svg" align="right" alt="" width="120" />

<!-- badges: start -->

[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build status](https://github.com/munterfi/sbplanr/workflows/R-CMD-check/badge.svg)](https://github.com/munterfi/sbplanr/actions)
[![pkgdown](https://github.com/munterfi/sbplanr/workflows/pkgdown/badge.svg)](https://github.com/munterfi/sbplanr/actions)
[![Codecov test coverage](https://codecov.io/gh/munterfi/sbplanr/branch/master/graph/badge.svg)](https://codecov.io/gh/munterfi/sbplanr?branch=master)
[![CodeFactor](https://www.codefactor.io/repository/github/munterfi/sbplanr/badge)](https://www.codefactor.io/repository/github/munterfi/sbplanr)

<!-- badges: end -->

Tool for placing bicycle sharing stations by iteratively minimizing a global energy of a model that reflects the station-based bicycle sharing system. The station locations are randomly initialized in the street network and iteratively optimized based on the reachable population in combination with walking and driving times. Initially forked from [munterfi/drtplanr](https://github.com/munterfi/drtplanr).

The model in the package example optimizes the positions of stations in an assumed bicycle sharing service for the municipality Bülach in Zurich, Switzerland.

|![](https://github.com/munterfi/sbplanr/blob/master/docs/example_i1000_energy_plot.png)|![](https://github.com/munterfi/sbplanr/blob/master/docs/example_i1000_station_map.png)|
|---|---|

## Getting started

Install the development version from [GitHub](https://github.com/munterfi/sbplanr/) with:

```r
remotes::install_github("munterfi/sbplanr")
```

Create an example model:

```r
# Example data
aoi <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "aoi")

pop <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "pop")

poi <-
  sf::st_read(system.file("example.gpkg", package = "sbplanr"), layer = "poi")[1,]

# Create model
m <- sb_sbm(
  model_name = "Buelach",
  aoi = aoi, pop = pop, poi = poi,
  n_sta = 15, m_seg = 100
)

# Iterate the model
m <- sb_iterate(m, 100)

# Visualize results
sb_plot(m)
sb_map(m)
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

<img src="https://render.githubusercontent.com/render/math?math=Eg = \sum_{s_1 \neq s_2} \sum_{c \in S_1} \sum_{d \in S_2} P_c * P_d * (Wt_{c} + Bt_{s1s2} + Wt_d)">

When the direct walking time between to populations is faster than the travel using the bicycle (walk to station, cycle, walk from station), than the direct walking travel is chosen.

### Optimization

The global energy of the model is optimized in iterations. In every iteration one station is randomly selected and moved to another position on the segmented street network. The global energy of the model state with the new candidate is calculated. If the global energy is lower as befor, the candidate is accepted and the next iteration starts. If the global energy is higher, the candidate is rejected with the probability $1-\alpha$. The probability $\alpha$ decreases exponentially as a function of the number of iterations ($i$):

<img src="https://render.githubusercontent.com/render/math?math=f(i) = \frac{1}{(i + 1)}">

The concept of sometimes allowing a bad candidate to be accepted is known as annealing. This technique prevents the optimization from being captured in a local minimum before the global minimum is reached.

## Authors

* Merlin Unterfinger (inital idea, package implementation) - [munterfi](https://github.com/munterfi)
* Thomas Hettinger (energy definition) - [thetti](https://github.com/thetti)
* David Masson (ideas and feedback on model optimization, annealing) - [panhypersebastos](https://github.com/panhypersebastos)

## References

* Initially forked from [munterfi/drtplanr](https://github.com/munterfi/drtplanr)
* [hereR](https://github.com/munterfi/hereR): R interface to the HERE REST APIs
* [BfS](https://www.bfs.admin.ch/): Population data for Switzerland
* [OSM](https://www.openstreetmap.org/): Street network data for routing purposes.

## Licence

* This repository is licensed under the GNU General Public License v3.0 - see the [LICENSE.md](LICENSE.md) file for details.
