# GritsNode
#
# Creates an instance of a node
GritsNode = (obj, marker) ->
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
  @_name = 'GritsNode'

  if typeof marker != 'undefined' and marker instanceof GritsMarker
    @marker = marker
  else
    @marker = new GritsMarker()

  @latLng = [latitude, longitude]

  @incomingThroughput = 0
  @outgoingThroughput = 0
  @level = 0

  @metadata = {}
  _.extend(@metadata, obj)
  
  @eventHandlers = {}

  return

GritsNode::setEventHandlers = (eventHandlers) ->
  for name, method of eventHandlers
    @eventHandlers[name] = _.bind(method, this)
