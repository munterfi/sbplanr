# sbplanr 0.0.0.9000

Experimental development version of the `sbplanr` package (`sbplanr`, name is
inspired by [stplanr](https://github.com/ropensci/stplanr)):
Tool for placing bicycle sharing stations by iteratively minimizing a global energy of a model that reflects the station-based bicycle sharing system. The station locations are randomly initialized in the street network and iteratively optimized based on the reachable population in combination with walking and driving times.

* Class `sbm` class: Demand-responsive transport model.
* Interface to `sbm` class: `sb_*()` functions.
* Package example: An assumed station-based bycicle sharing service for the community of
Buelach in Zurich, Switzerland.
