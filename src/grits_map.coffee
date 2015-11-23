_imagePath = 'packages/bevanhunt_leaflet/images'
# GritsMap
#
# Creates an instance of a map
GritsMap = (element, view, baseLayers) ->
  @_name = 'GritsMap'
  
  @_element = element or 'grits-map'
  
  @_view = view or {}
  @_view.latlong = view.latlong or [37.8, -92]
  
  @_overlays = {}
  @_overlayControl = null
  
  @_layers = {}
  
  L.Icon.Default.imagePath = _imagePath

  OpenStreetMap = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    key: '1234'
    layerName: 'OpenStreetMap'
    styleId: 22677)
  
  layers = baseLayers or [OpenStreetMap]
  @_baseLayers = {}
  for baseLayer in layers
    @_baseLayers[baseLayer.options.layerName] = baseLayer
    
  @_map = null  
  return

GritsMap::init = (css) ->
  self = this
  
  #set the container height
  css = css or {'height': window.innerHeight}
  
  $(window).resize ->    
    $('#'+self._element).css css
  $(window).resize()
  
  # the base layers
  baseLayers = Object.keys(self._baseLayers).map((k) -> self._baseLayers[k])
  
  #init the map
  @_map = L.map(self._element,
    zoomControl: false
    noWrap: true
    maxZoom: 18
    minZoom: 0
    layers: [ baseLayers[0] ]).setView(self._view.latlong, self._view.zoom)
  
  self._drawOverlayControls()
  return

# addLayer
GritsMap::addLayer = (layer) ->
  if typeof layer == 'undefined'
    throw new Error('A layer must be defined')
    return
  if !layer instanceof GritsLayer
    throw new Error('A map requires a valid GritsLayer instance')
    return
  @_layers[layer._name] = layer
  return layer

# getLayer
GritsMap::getLayer = (name) ->
  if typeof name == 'undefined'
    throw new Error('A name must be defined')
    return
  if @_layers.hasOwnProperty(name) == true
    return @_layers[name]
  return null
# getMap
#
# return the underlying Leaflet map
GritsMap::getMap = () ->
  return @_map

# drawOverlayControls
#
# Draws the overlay controls within the control box in the upper-right
# corner of the map.  It uses @overlayControl to place the reference of
# the overlay controls.
GritsMap::_drawOverlayControls = () ->
  if @_overlayControl == null
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @_map
  else
    @_overlayControl.removeFrom(@_map)
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @_map

# addOverlayControl
#
# Adds a new overlay control to the map
GritsMap::addOverlayControl = (layerName, layerGroup) ->
  @_overlays[layerName] = layerGroup
  @_drawOverlayControls()

# removeOverlayControl
#
# Removes overlay control from the map
GritsMap::removeOverlayControl = (layerName) ->
  if @_overlays.hasOwnProperty layerName
    delete @_overlays[layerName]
    @_drawOverlayControls()

# addControl
#
# Add a single control to the map.
GritsMap::addControl = (position, selector, content) ->
    control = L.control(position: position)
    control.onAdd = @_onAddHandler(selector, content)
    control.addTo @_map

# Adds control overlays to the map
# -Module Selector
# -Path details
# -Node details
GritsMap::_addDefaultControls = () ->

  return

# onAddHandler
#
# @note This method is used for initializing dialog boxes created via addControls
GritsMap::_onAddHandler = (selector, html) ->
  ->
    _div = L.DomUtil.create('div', selector)
    _div.innerHTML = html
    L.DomEvent.disableClickPropagation _div
    L.DomEvent.disableScrollPropagation _div
    _div

# setView
#
# wrapper, Sets the view of the map (geographical center and zoom) with the given animation options.
# @param [Array] latLng - the poing
# @param [Integet] zoom - the zoom level
# @param [Object] options - the animation options
GritsMap::setView = (latLng, zoom, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setView(latLng, zoom, options)
  return

# fitBounds
#
# wrapper, Sets a map view that contains the given geographical bounds with the maximum zoom level possible.
GritsMap::fitBounds = (latLngBounds, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.fitBounds(latLngBounds, options)
  return

# setMaxBounds
#
# wrapper, Restricts the map view to the given bounds
GritsMap::setMaxBounds = (latLngBounds) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setMaxBounds(latLngBounds)
  return

# getBounds
#
# wrapper, Returns the LatLngBounds of the current map view.
GritsMap::getBounds = (latLngBounds) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.getBounds()
  return

# setZoom
#
# wrapper, Sets the zoom of the map.
# @param [Array] latLng - the poing
# @param [Integet] zoom - the zoom level
# @param [Object] options - the animation options
GritsMap::setZoom = (zoom, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setZoom(zoom, options)
  return

# zoomIn
#
# wrapper, Increases the zoom of the map by delta (1 by default).
# @param [Integer] delta
GritsMap::zoomIn = (delta) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.zoomIn(delta)
  return

# zoomOut
#
# wrapper, Decreases the zoom of the map by delta (1 by default).
# @param [Integer] delta
GritsMap::zoomOut = (delta) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.zoomOut(delta)
  return

# getZoom
#
# wrapper, Returns the current zoom of the map view.
GritsMap::getZoom = () ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.getZoom()
  return

# panTo
#
# wrapper, Pans the map to a given center. Makes an animated pan if new center is not more than one screen away from the current one.
GritsMap::panTo = (latLng, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.panTo(latLng, options)
  return
  
# remove
#
# wrapper, Destroys the map and clears all related event listeners.
GritsMap::remove = () ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.remove()
  return
