# GritsMarker
#
# Creates an instance of a marker.
#  obj that contains:
#    _id: a unique identifier
#   loc: a geoJSON object of type 'Point'
#  handlers:
#    onClickHandler: function
#
GritsMarker = (width, height, href, colorScale) ->
  self = this
  if typeof width == 'undefined'
    self.height = 80
  else
    self.height = height

  if typeof height == 'undefined'
    self.width = 55
  else
    self.width = width

  if typeof href == 'undefined'
    self.href = '/packages/grits_grits-net-mapper/images/marker-icon.svg'
  else
    self.href = href

  if typeof colorScale == 'undefined'
    self.colorScale =
      9: '282828'
      8: '383838'
      7: '484848'
      6: '585858'
      5: '686868'
      4: '787878'
      3: '888888'
      2: '989898'
      1: 'A8A8A8'
      0: 'B8B8B8'
  else
    self.colorScale = colorScale

  @_name = 'Marker'
  return
