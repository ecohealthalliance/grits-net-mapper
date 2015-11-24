_imagePath = 'packages/bevanhunt_leaflet/images'
# Creates an instance of a map
#
# @param [String]
# @param [Object] view, object cointaining latlong point for center of map
# @param [Array] baseLayers, array containing L.tileLayer objects
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

# initializes the map
#
# @param [Object] css, object cointaining css styles for the resize event
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

# adds a layer reference to the map object
#
# @note This does not add the layer to the Leaflet map.  Its just a container
# @param [Object] layer, a GritsLayer instance
GritsMap::addLayer = (layer) ->
  if typeof layer == 'undefined'
    throw new Error('A layer must be defined')
    return
  if !layer instanceof GritsLayer
    throw new Error('A map requires a valid GritsLayer instance')
    return
  @_layers[layer._name] = layer
  return layer

# gets a layer refreence from the map object
#
# @param [String] name, a string containing the name of the layer as shown
#  in the UI layer controls
GritsMap::getLayer = (name) ->
  if typeof name == 'undefined'
    throw new Error('A name must be defined')
    return
  if @_layers.hasOwnProperty(name) == true
    return @_layers[name]
  return null

# returns the underlying Leaflet map
GritsMap::getMap = () ->
  return @_map

# draws the overlay controls within the control box in the upper-right
# corner of the map.  It uses @_overlayControl to place the reference of
# the overlay controls.
GritsMap::_drawOverlayControls = () ->
  if @_overlayControl == null
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @_map
  else
    @_overlayControl.removeFrom(@_map)
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @_map

# adds a new overlay control to the map
#
# @param [String] layerName, string containing the name of the layer
# @param [Object] layerGroup, the layerGroup object to add to the map controls
GritsMap::addOverlayControl = (layerName, layerGroup) ->
  @_overlays[layerName] = layerGroup
  @_drawOverlayControls()

# removes overlay control from the map
#
# @param [String] layerName, string containing the name of the layer
GritsMap::removeOverlayControl = (layerName) ->
  if @_overlays.hasOwnProperty layerName
    delete @_overlays[layerName]
    @_drawOverlayControls()

# add a single control to the map.
#
# @param [String] position, string containing the position of the layer
# @param [String] selector, class to add to the control div
# @param [String] content, string (can be html) containing the content of the
#  div
GritsMap::addControl = (position, selector, content) ->
    control = L.control(position: position)
    control.onAdd = @_onAddHandler(selector, content)
    control.addTo @_map

# method for initializing dialog boxes created via addControls
GritsMap::_onAddHandler = (selector, html) ->
  ->
    _div = L.DomUtil.create('div', selector)
    _div.innerHTML = html
    L.DomEvent.disableClickPropagation _div
    L.DomEvent.disableScrollPropagation _div
    _div

# sets the view of the map (geographical center and zoom) with the given
# animation options.
#
# @param [Array] latLng, the 
# @param [Integer] zoom, the zoom level
# @param [Object] options, the animation options
GritsMap::setView = (latLng, zoom, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setView(latLng, zoom, options)
  return

# sets a map view that contains the given geographical bounds with the maximum
#  zoom level possible.
#
# @param [Array] latLngBounts, array of point arrays
#   @example [[40.712, -74.227], [40.774, -74.125]]
#   http://leafletjs.com/reference.html#latlngbounds
# @param [Object] options, object containing paddingTopLeft, paddingBottomRight,
#   padding, and maxZoom properties
#   http://leafletjs.com/reference.html#map-fitboundsoptions
GritsMap::fitBounds = (latLngBounds, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.fitBounds(latLngBounds, options)
  return

# restricts the map view to the given bounds
#
# @param [Array] latLngBounts, array of point arrays
#   @example [[40.712, -74.227], [40.774, -74.125]]
#   http://leafletjs.com/reference.html#latlngbounds
GritsMap::setMaxBounds = (latLngBounds) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setMaxBounds(latLngBounds)
  return

# returns the LatLngBounds of the current map view.
GritsMap::getBounds = () ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.getBounds()
  return

# sets the zoom of the map.
#
# @param [Array] latLng - the poing
# @param [Integet] zoom - the zoom level
# @param [Object] options - the animation options
GritsMap::setZoom = (zoom, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.setZoom(zoom, options)
  return

# increases the zoom of the map by delta (1 by default).
# @param [Integer] delta
GritsMap::zoomIn = (delta) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.zoomIn(delta)
  return

# decreases the zoom of the map by delta (1 by default).
#
# @param [Integer] delta
GritsMap::zoomOut = (delta) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.zoomOut(delta)
  return

# returns the current zoom of the map view.
GritsMap::getZoom = () ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.getZoom()
  return

# pans the map to a given center. Makes an animated pan if new center is not
# more than one screen away from the current one.
#
# @param [Array] latLng, array containing a point
# @param [Object] options, object cointaining animate, duration, easeLinerity,
#  and noMoveStart properties.
GritsMap::panTo = (latLng, options) ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.panTo(latLng, options)
  return
  
# destroys the map and clears all related event listeners.
GritsMap::remove = () ->
  if _.isNull(@_map)
    throw new Error('The map has not be initialized.')
  @_map.remove()
  return
