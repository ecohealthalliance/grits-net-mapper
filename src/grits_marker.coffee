# GritsMarker
#
# Creates an instance of a marker
GritsMarker = (width, height, href, colorScale) ->
  @_name = 'GritsMarker'
  
  if typeof width == 'undefined'
    @height = 80
  else
    @height = height

  if typeof height == 'undefined'
    @width = 55
  else
    @width = width

  if typeof href == 'undefined'
    @href = '/packages/grits_grits-net-mapper/images/marker-icon.svg'
  else
    @href = href

  if typeof colorScale == 'undefined'
    @colorScale =
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
    @colorScale = colorScale

  return
