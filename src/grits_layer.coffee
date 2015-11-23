# GritsLayer
#
# Creates an instance of a layer
GritsLayer = () ->
  @_name = 'Layer'
  @_data = {}
  
  @_map = null
  @_layer = null
  @_layerGroup = null
  @_normalizedCI = 1
  return

# remove
#
# removes the layerGroup from the map
GritsLayer::_removeLayerGroup = () ->
  if !(typeof @_layerGroup == 'undefined' or @_layerGroup == null)
    @_map.map.removeLayer(@_layerGroup)  
  @_layerGroup = null
  return
# add
#
# adds the layerGroup to the map
GritsLayer::_addLayerGroup = () ->  
  @_layerGroup = L.layerGroup([@_layer])
  @_map.addOverlayControl(@_name, @_layerGroup)
  @_map.map.addLayer(@_layerGroup)
  return

# draw
#
# Sets the data for the heatmap plugin and updates the heatmap
GritsLayer::draw = () ->
  @_layer.draw()
  return

# clear
#
# Clears the Nodes and layers
GritsLayer::clear = () ->
  @_data = {}
  @_removeLayerGroup()
  @_addLayerGroup()