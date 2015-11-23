/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	eval("__webpack_require__(1);\n__webpack_require__(2);\n__webpack_require__(3);\n__webpack_require__(4);\nmodule.exports = __webpack_require__(5);\n\n\n/*****************\n ** WEBPACK FOOTER\n ** multi main\n ** module id = 0\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///multi_main?");

/***/ },
/* 1 */
/***/ function(module, exports) {

	eval("var GritsLayer;\n\nGritsLayer = function() {\n  this._name = 'Layer';\n  this._data = {};\n  this._map = null;\n  this._layer = null;\n  this._layerGroup = null;\n  this._normalizedCI = 1;\n};\n\nGritsLayer.prototype._removeLayerGroup = function() {\n  if (!(typeof this._layerGroup === 'undefined' || this._layerGroup === null)) {\n    this._map.map.removeLayer(this._layerGroup);\n  }\n  this._layerGroup = null;\n};\n\nGritsLayer.prototype._addLayerGroup = function() {\n  this._layerGroup = L.layerGroup([this._layer]);\n  this._map.addOverlayControl(this._name, this._layerGroup);\n  this._map.map.addLayer(this._layerGroup);\n};\n\nGritsLayer.prototype.draw = function() {\n  this._layer.draw();\n};\n\nGritsLayer.prototype.clear = function() {\n  this._data = {};\n  this._removeLayerGroup();\n  return this._addLayerGroup();\n};\n\n\n/*****************\n ** WEBPACK FOOTER\n ** ./src/grits_layer.coffee\n ** module id = 1\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///./src/grits_layer.coffee?");

/***/ },
/* 2 */
/***/ function(module, exports) {

	eval("var GritsMap, _imagePath;\n\n_imagePath = 'packages/bevanhunt_leaflet/images';\n\nGritsMap = function(element, view, baseLayers) {\n  var OpenStreetMap, baseLayer, i, layers, len;\n  this._name = 'GritsMap';\n  this._element = element || 'grits-map';\n  this._view = view || {};\n  this._view.latlong = view.latlong || [37.8, -92];\n  this._overlays = {};\n  this._overlayControl = null;\n  this._layers = {};\n  L.Icon.Default.imagePath = _imagePath;\n  OpenStreetMap = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {\n    key: '1234',\n    layerName: 'OpenStreetMap',\n    styleId: 22677\n  });\n  layers = baseLayers || [OpenStreetMap];\n  this._baseLayers = {};\n  for (i = 0, len = layers.length; i < len; i++) {\n    baseLayer = layers[i];\n    this._baseLayers[baseLayer.options.layerName] = baseLayer;\n  }\n  this.map = null;\n};\n\nGritsMap.prototype.init = function(css) {\n  var baseLayers, self;\n  self = this;\n  css = css || {\n    'height': window.innerHeight\n  };\n  $(window).resize(function() {\n    return $('#' + self._element).css(css);\n  });\n  $(window).resize();\n  baseLayers = Object.keys(self._baseLayers).map(function(k) {\n    return self._baseLayers[k];\n  });\n  this.map = L.map(self._element, {\n    zoomControl: false,\n    noWrap: true,\n    maxZoom: 18,\n    minZoom: 0,\n    layers: [baseLayers[0]]\n  }).setView(self._view.latlong, self._view.zoom);\n  self._drawOverlayControls();\n  self._addDefaultControls();\n};\n\nGritsMap.prototype.addLayer = function(layer) {\n  if (typeof layer === 'undefined') {\n    throw new Error('A layer must be defined');\n    return;\n  }\n  if (!layer instanceof GritsLayer) {\n    throw new Error('A map requires a valid GritsLayer instance');\n    return;\n  }\n  this._layers[layer._name] = layer;\n  return layer;\n};\n\nGritsMap.prototype.getLayer = function(name) {\n  if (typeof name === 'undefined') {\n    throw new Error('A name must be defined');\n    return;\n  }\n  if (this._layers.hasOwnProperty(name) === true) {\n    return this._layers[name];\n  }\n  return null;\n};\n\nGritsMap.prototype.getMap = function() {\n  return this._map;\n};\n\nGritsMap.prototype._drawOverlayControls = function() {\n  if (this._overlayControl === null) {\n    return this._overlayControl = L.control.layers(this._baseLayers, this._overlays).addTo(this.map);\n  } else {\n    this._overlayControl.removeFrom(this.map);\n    return this._overlayControl = L.control.layers(this._baseLayers, this._overlays).addTo(this.map);\n  }\n};\n\nGritsMap.prototype.addOverlayControl = function(layerName, layerGroup) {\n  this._overlays[layerName] = layerGroup;\n  return this._drawOverlayControls();\n};\n\nGritsMap.prototype.removeOverlayControl = function(layerName) {\n  if (this._overlays.hasOwnProperty(layerName)) {\n    delete this._overlays[layerName];\n    return this._drawOverlayControls();\n  }\n};\n\nGritsMap.prototype.addControl = function(position, selector, content) {\n  var control;\n  control = L.control({\n    position: position\n  });\n  control.onAdd = this._onAddHandler(selector, content);\n  return control.addTo(this.map);\n};\n\nGritsMap.prototype._addDefaultControls = function() {\n  var nodeDetails, pathDetails;\n  pathDetails = L.control({\n    position: 'bottomright'\n  });\n  pathDetails.onAdd = this._onAddHandler('info path-detail', '');\n  pathDetails.addTo(this.map);\n  $('.path-detail').hide();\n  nodeDetails = L.control({\n    position: 'bottomright'\n  });\n  nodeDetails.onAdd = this._onAddHandler('info node-detail', '');\n  nodeDetails.addTo(this.map);\n  $('.node-detail').hide();\n  return $(\".path-detail-close\").on('click', function() {\n    return $('.path-detail').hide();\n  });\n};\n\nGritsMap.prototype._onAddHandler = function(selector, html) {\n  return function() {\n    var _div;\n    _div = L.DomUtil.create('div', selector);\n    _div.innerHTML = html;\n    L.DomEvent.disableClickPropagation(_div);\n    L.DomEvent.disableScrollPropagation(_div);\n    return _div;\n  };\n};\n\nGritsMap.prototype.setView = function(latLng, zoom, options) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.setView(latLng, zoom, options);\n};\n\nGritsMap.prototype.fitBounds = function(latLngBounds, options) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.fitBounds(latLngBounds, options);\n};\n\nGritsMap.prototype.setMaxBounds = function(latLngBounds) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.setMaxBounds(latLngBounds);\n};\n\nGritsMap.prototype.getBounds = function(latLngBounds) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.getBounds();\n};\n\nGritsMap.prototype.setZoom = function(zoom, options) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.setZoom(zoom, options);\n};\n\nGritsMap.prototype.zoomIn = function(delta) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.zoomIn(delta);\n};\n\nGritsMap.prototype.zoomOut = function(delta) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.zoomOut(delta);\n};\n\nGritsMap.prototype.getZoom = function() {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.getZoom();\n};\n\nGritsMap.prototype.panTo = function(latLng, options) {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.panTo(latLng, options);\n};\n\nGritsMap.prototype.remove = function() {\n  if (_.isNull(this.map)) {\n    throw new Error('The map has not be initialized.');\n  }\n  this.map.remove();\n};\n\n\n/*****************\n ** WEBPACK FOOTER\n ** ./src/grits_map.coffee\n ** module id = 2\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///./src/grits_map.coffee?");

/***/ },
/* 3 */
/***/ function(module, exports) {

	eval("var GritsMarker;\n\nGritsMarker = function(width, height, colorScale) {\n  this._name = 'GritsMarker';\n  if (typeof width === 'undefined') {\n    this.height = 25;\n  } else {\n    this.height = height;\n  }\n  if (typeof height === 'undefined') {\n    this.width = 15;\n  } else {\n    this.width = width;\n  }\n  if (typeof colorScale === 'undefined') {\n    this.colorScale = {\n      9: '282828',\n      8: '383838',\n      7: '484848',\n      6: '585858',\n      5: '686868',\n      4: '787878',\n      3: '888888',\n      2: '989898',\n      1: 'A8A8A8',\n      0: 'B8B8B8'\n    };\n  } else {\n    this.colorScale = colorScale;\n  }\n};\n\n\n/*****************\n ** WEBPACK FOOTER\n ** ./src/grits_marker.coffee\n ** module id = 3\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///./src/grits_marker.coffee?");

/***/ },
/* 4 */
/***/ function(module, exports) {

	eval("var GritsNode;\n\nGritsNode = function(obj, marker) {\n  var latitude, longitude;\n  if (typeof obj === 'undefined' || obj === null) {\n    throw new Error('A node requires valid input object');\n    return;\n  }\n  if (obj.hasOwnProperty('_id') === false) {\n    throw new Error('A node requires the \"_id\" unique identifier property');\n    return;\n  }\n  if (obj.hasOwnProperty('loc') === false) {\n    throw new Error('A node requires the \"loc\" geoJSON location property');\n    return;\n  }\n  longitude = obj.loc.coordinates[0];\n  latitude = obj.loc.coordinates[1];\n  this._id = obj._id;\n  this._name = 'GritsNode';\n  if (typeof marker !== 'undefined' && marker instanceof GritsMarker) {\n    this.marker = marker;\n  } else {\n    this.marker = new GritsMarker();\n  }\n  this.latLng = [latitude, longitude];\n  this.incomingThroughput = 0;\n  this.outgoingThroughput = 0;\n  this.level = 0;\n  this.metadata = {};\n  _.extend(this.metadata, obj);\n  this.eventHandlers = {};\n};\n\nGritsNode.prototype.setEventHandlers = function(eventHandlers) {\n  var method, name, results;\n  results = [];\n  for (name in eventHandlers) {\n    method = eventHandlers[name];\n    results.push(this.eventHandlers[name] = _.bind(method, this));\n  }\n  return results;\n};\n\n\n/*****************\n ** WEBPACK FOOTER\n ** ./src/grits_node.coffee\n ** module id = 4\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///./src/grits_node.coffee?");

/***/ },
/* 5 */
/***/ function(module, exports) {

	eval("var GritsPath;\n\nGritsPath = function(obj, throughput, level, origin, destination) {\n  this._name = 'GritsPath';\n  if (typeof obj === 'undefined' || !(obj instanceof Object)) {\n    throw new Error(this._name + \" - obj must be defined and of type Object\");\n    return;\n  }\n  if (obj.hasOwnProperty('_id') === false) {\n    throw new Error(this._name + \" - obj requires the _id property\");\n    return;\n  }\n  if (typeof throughput === 'undefined') {\n    throw new Error(this._name + \" - throughput must be defined\");\n    return;\n  }\n  if (typeof level === 'undefined') {\n    throw new Error(this._name + \" - level must be defined\");\n    return;\n  }\n  if (typeof origin === 'undefined' || !(origin instanceof GritsNode)) {\n    throw new Error(this._name + \" - origin must be defined and of type GritsNode\");\n    return;\n  }\n  if (typeof origin === 'undefined' || !(destination instanceof GritsNode)) {\n    throw new Error(this._name + \" - destination must be defined and of type GritsNode\");\n    return;\n  }\n  this._id = CryptoJS.MD5(origin._id + destination._id).toString();\n  this.level = level;\n  this.throughput = throughput;\n  this.normalizedPercent = 0;\n  this.occurrances = 1;\n  this.origin = origin;\n  this.destination = destination;\n  this.midPoint = this.getMidPoint();\n  this.element = null;\n  this.color = '#fdcc8a';\n  this.metadata = {};\n  _.extend(this.metadata, obj);\n  this.eventHandlers = {};\n};\n\nGritsPath.prototype.getMidPoint = function() {\n  var latDif, lngDif, midPoint, ud;\n  ud = true;\n  midPoint = [];\n  latDif = Math.abs(this.origin.latLng[0] - this.destination.latLng[0]);\n  lngDif = Math.abs(this.origin.latLng[1] - this.destination.latLng[1]);\n  ud = latDif > lngDif ? false : true;\n  if (this.origin.latLng[0] > this.destination.latLng[0]) {\n    if (ud) {\n      midPoint[0] = this.destination.latLng[0] + (latDif / 4);\n    } else {\n      midPoint[0] = this.origin.latLng[0] - (latDif / 4);\n    }\n  } else {\n    if (ud) {\n      midPoint[0] = this.destination.latLng[0] - (latDif / 4);\n    } else {\n      midPoint[0] = this.origin.latLng[0] + (latDif / 4);\n    }\n  }\n  midPoint[1] = (this.origin.latLng[1] + this.destination.latLng[1]) / 2;\n  return midPoint;\n};\n\nGritsPath.prototype.setEventHandlers = function(eventHandlers) {\n  var method, name, results;\n  results = [];\n  for (name in eventHandlers) {\n    method = eventHandlers[name];\n    results.push(this.eventHandlers[name] = _.bind(method, this));\n  }\n  return results;\n};\n\n\n/*****************\n ** WEBPACK FOOTER\n ** ./src/grits_path.coffee\n ** module id = 5\n ** module chunks = 0\n **/\n//# sourceURL=webpack:///./src/grits_path.coffee?");

/***/ }
/******/ ]);