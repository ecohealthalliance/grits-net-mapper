# GritsControl represents a control on the map
#
# @param [String] htmlContent, the content of the control
# @param [Integer] zindex, the z-index to be applied to the container
# @param [String] position, one of 'topleft', 'topright', 'bottomleft',
#  or 'bottomright'
# @param [String] css, the css class to be applied to the container
class GritsControl extends L.Control
  constructor: (htmlContent, zIndex, position, css) ->
    L.Control.call(this)
    if typeof htmlContent == 'undefined'
      throw new Error('GritsConrol must have htmlContent defined')
    @htmlContent = htmlContent
    @position = position or 'bottomleft'
    @options =
      position: position
    @css = css or 'info'
    @zIndex = zIndex or 7 # the leaflet default

  onAdd: (map) ->
    container = L.DomUtil.create('div', @css)
    container.innerHTML = @htmlContent
    container.style.zIndex = @zIndex
    L.DomEvent.disableClickPropagation(container)
    L.DomEvent.disableScrollPropagation(container)
    return container