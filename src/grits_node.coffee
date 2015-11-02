# GritsNode
#
# Creates an instance of a node.
#  obj that contains:
#    _id: a unique identifier
#   loc: a geoJSON object of type 'Point'
#  handlers:
#    onClickHandler: function
#
GritsNode = (obj, marker) ->
  self = this
  if typeof obj == 'undefined' or obj == null
    throw new Error('A node requires valid input object')
    return

  if obj.hasOwnProperty('_id') == false
    throw new Error('A node requires the "_id" unique identifier property')
    return

  if obj.hasOwnProperty('loc') == false
    throw new Error('A node requires the "loc" geoJSON location property')
    return

  longitude = obj.loc.coordinates[0]
  latitude = obj.loc.coordinates[1]

  @_id = obj._id
  @_name = 'Node'

  if typeof marker != 'undefined' and marker instanceof GritsMarker
    self.marker = marker
  else
    self.marker = new GritsMarker()

  @latLng = [latitude, longitude]

  @incomingThroughput = 0
  @outgoingThroughput = 0
  @level = 0

  @metadata = Object.assign(obj)

  return

GritsNode::setClickHandler = (fn) ->
  @clickHandler = fn