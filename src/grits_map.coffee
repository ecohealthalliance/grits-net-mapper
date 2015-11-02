# GritsMap
#
# Creates an instance of a map
GritsMap = (element, view) ->
  @_name = 'GritsMap'
  @_element = element or 'grits-map'
  @_view = view or {}
  @_view.latlong = view.latlong or [37.8, -92]

  OpenStreetMap = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    key: '1234'
    layerName: 'OpenStreetMap'
    styleId: 22677)

  baseLayers = baseLayers or [OpenStreetMap]

  @map = L.map(element,
    zoomControl: false
    noWrap: true
    maxZoom: 18
    minZoom: 0
    layers: [ baseLayers[0] ]).setView(view.latlong, view.zoom)

  tempBaseLayers = {}
  for baseLayer in baseLayers
      tempBaseLayers[baseLayer.options.layerName] = baseLayer
  @_baseLayers = tempBaseLayers

  @_overlayControl = {}

  @addControls()
  return

# drawOverlayControls
#
# Draws the overlay controls within the control box in the upper-right
# corner of the map.  It uses @overlayControl to place the reference of
# the overlay controls.
GritsMap::drawOverlayControls = () ->
  if @_overlayControl == null
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @map
  else
    @_overlayControl.removeFrom(@map)
    @_overlayControl = L.control.layers(@_baseLayers, @_overlays).addTo @map

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
    control.onAdd = @onAddHandler(selector, content)
    control.addTo @map

# Adds control overlays to the map
# -Module Selector
# -Path details
# -Node details
GritsMap::addControls = () ->
    pathDetails = L.control(position: 'bottomright')
    pathDetails.onAdd = @onAddHandler('info path-detail', '')
    pathDetails.addTo @map
    $('.path-detail').hide()
    nodeDetails = L.control(position: 'bottomright')
    nodeDetails.onAdd = @onAddHandler('info node-detail', '')
    nodeDetails.addTo @map
    $('.node-detail').hide()

# @note This method is used for initializing dialog boxes created via addControls
GritsMap::onAddHandler = (selector, html) ->
  ->
    @_div = L.DomUtil.create('div', selector)
    @_div.innerHTML = html
    L.DomEvent.disableClickPropagation @_div
    L.DomEvent.disableScrollPropagation @_div
    @_div
