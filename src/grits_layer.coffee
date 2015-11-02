# GritsLayer
#
# Creates an instance of a layer
GritsLayer = (map, options, drawCallback) ->
  @_name = 'GritsLayer'
  @data = {}

  if (typeof map == 'undefined' or !(map instanceof L.Map))
    throw new Error('A layer requires valid Leaflet map object')
    return

  if typeof drawCallback == 'undefined'
    throw new Error('A layer requires valid drawCallback function')
    return

  @map = map
  @drawCallback = drawCallback

  if typeof options == 'undefined'
    @options = {}
  else
    @options = options

  @minValue = null
  @maxValue = null
  @layer = null
  @layerGroup = null

  @_bindMapEvents()
  @addLayer()
  return

# _bindEvents
#
# Binds to the @map.on 'overlyadd' and 'overlayremove' methods
GritsLayer::_bindMapEvents = () ->
  self = this
  @map.on(
    overlayadd: (e) ->
      if e.name == self._name
        if self.options.hasOwnProperty 'overlayadd' and typeof self.options == 'function'
          self.options.overlayadd()
    overlayremove: (e) ->
      if e.name == self._name
        if self.options.hasOwnProperty 'overlayremove' and typeof self.options == 'function'
          self.options.overlayremove()
  )
# remove
#
# removes the heatmap layerGroup from the map
GritsLayer::removeLayer = () ->
  @map.removeLayer(@layerGroup)
  @layer = null
  @layerGroup = null
  return
# add
#
# adds the heatmap layerGroup to the map
GritsLayer::addLayer = () ->
  @layer = L.d3SvgOverlay(_.bind(@_drawCallback, this), @options)
  @layerGroup = L.layerGroup([@layer])
  #TODO
  #Meteor.gritsUtil.addOverlayControl(@_name, @layerGroup)
  @map.addLayer(@layerGroup)
  return

# drawCallback
#
# Note: makes used of _.bind within the constructor so 'this' is encapsulated
# properly
GritsLayer::_drawCallback = (selection, projection) ->
  drawings = _.values(@data)
  drawingsCount = drawings.length
  if drawingsCount <= 0
    return
  if typeof self.drawCallback == 'function'
    @drawCallback(drawings, selection, projection)
  return

GritsLayer::getRelativeThroughput = (drawing) ->
  maxAllowed = 0.9
  r = 0.0
  if @maxValue > 0
    r = ((drawing.incomingThroughput + drawing.outgoingThroughput) / @maxValue)
  if r > maxAllowed
    return maxAllowed
  return +(r).toFixed(1)

GritsLayer::getMarkerHref = (drawing) ->
  v = drawing.marker.grayscale[ @getRelativeThroughput(drawing) * 10]
  if !(typeof v == 'undefined' or v == null)
    href = "/packages/grits_grits-net-meteor/client/images/marker-icon-#{v}.png"
  else
    href = '/packages/grits_grits-net-meteor/client/images/marker-icon-B8B8B8.png'
  return href

# draw
#
# Sets the data for the heatmap plugin and updates the heatmap
GritsLayer::draw = () ->
  @layer.draw()
  return

# clear
#
# Clears the Nodes and layers
GritsLayer::clear = () ->
  @data = {}
  @removeLayer()
  @addLayer()
