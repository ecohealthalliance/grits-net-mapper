# grits-net-mapper
![Build Status](https://circleci.com/gh/ecohealthalliance/grits-net-mapper.svg?style=shield&circle-token=c4714a094e9304774ad75278d18e534853fbbeed)

A Meteor package that provides an API for displaying GRITS transportation data on a Leaflet map.

## Features

* [GritsControl](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsControl) - Extends [L.Control](http://leafletjs.com/reference.html#control), a custom control class that allows for controls to have varying z-index.

* [GritsLayer](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsLayer) - Interface for implementing a custom layer.

* [GritsMap](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsMap) - Extends [L.Map](http://leafletjs.com/reference.html#map-class), a custom map class with with methods for adding/removing overlay controls.

* [GritsMarker](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsMarker) - class that represents an SVG marker.

* [GritsNode](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsNode) - class that represents a unique point on the map

* [GritsPath](https://github.com/ecohealthalliance/grits-net-mapper/wiki/GritsPath) - class that represents a connection between two nodes
