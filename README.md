# grits-net-mapper
![Build Status](https://circleci.com/gh/ecohealthalliance/grits-net-mapper.svg?style=shield&circle-token=c4714a094e9304774ad75278d18e534853fbbeed)

A Meteor package for displaying transportation data on a Leaflet map.

## Features

* Paths are drawn to resemble great circles using [Turfjs](https://github.com/turfjs/turf/)

* Path directional chevrons are attached to the Paths using [Leaflet.PolylineDecorator](https://github.com/bbecquet/Leaflet.PolylineDecorator)

* Paths are drawn with a normalized color ramp, meaning path color and weight is driven by its relation to all other paths within the current filter criteria.

## [L.MapPath](https://github.com/ecohealthalliance/grits-net-meteor/wiki/API#user-content-lmappath)
An object representing a set of flights with the same departure and arrival airports.

## [L.MapNode](https://github.com/ecohealthalliance/grits-net-meteor/wiki/API#user-content-lmapnode)
An objection representing an airport

