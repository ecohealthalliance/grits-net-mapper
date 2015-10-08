require "leaflet-polylinedecorator/leaflet.polylineDecorator.js"
turf = require "turf"

L.MapPath = L.Path.extend(
  id: null
  map: null
  smoothFactor: 1.0
  pointList: null
  pathLine: null
  pathLineDecorator: null
  origin: null
  destination: null
  destWAC: null
  miles: null
  origWAC: null
  totalSeats: null
  seats_week: null
  stops: null
  flights: 0
  visible: false
  normalizedPercent: 0
  onAdd: (map) ->
    @show()
    return
  show: ->
    @visible = true
    if @pathLine != null
      @pathLine.addTo @map
    if @pathLineDecorator != null
      @pathLineDecorator.addTo @map
    if @departureAirport != null and @departureAirport.visible == false
      @departureAirport.marker.addTo @map
    if @arrivalAirport != null and @arrivalAirport.visible == false
      @arrivalAirport.marker.addTo @map
    return
  hide: ->
    @visible = false
    if @pathLine != null
      @map.removeLayer @pathLine
    if @pathLineDecorator != null
      @map.removeLayer @pathLineDecorator
    return
  initialize: (flight, map) ->
    @map = map
    @visible = true
    @id = flight['_id']
    if flight.departureAirport != null
      @departureAirport = new (L.MapNode)(flight.departureAirport, @map)
    if flight.arrivalAirport != null
      @arrivalAirport = new (L.MapNode)(flight.arrivalAirport, @map)
    @miles = flight.Miles
    @origWAC = flight['Orig WAC']
    @totalSeats = flight.totalSeats
    @seats_week = flight['Seats/Week']
    @stops = flight.Stops
    @pointList = [
      @departureAirport.latlng
      @arrivalAirport.latlng
    ]
    L.MapPaths.addInitializedPath this
  midPoint: (points) ->
    ud = true
    midPoint = []
    latDif = Math.abs(points[0].lat - (points[1].lat))
    lngDif = Math.abs(points[0].lng - (points[1].lng))
    ud = if latDif > lngDif then false else true
    if points[0].lat > points[1].lat
      if ud
        midPoint[0] = points[1].lat + (latDif / 4)
      else
        midPoint[0] = points[0].lat - (latDif / 4)
    else
      if ud
        midPoint[0] = points[1].lat - (latDif / 4)
      else
        midPoint[0] = points[0].lat + (latDif / 4)
    midPoint[1] = (points[0].lng + points[1].lng) / 2
    midPoint
  calculateArch: ->
    curved = undefined
    line = undefined
    line = 'geometry': 'coordinates': [
      [
        @departureAirport.latlng.lat
        @departureAirport.latlng.lng
      ]
      @midPoint([
        @departureAirport.latlng
        @arrivalAirport.latlng
      ])
      [
        @arrivalAirport.latlng.lat
        @arrivalAirport.latlng.lng
      ]
    ]
    curved = turf.bezier(line, 10000, 1)
    @pointList = curved.geometry.coordinates
    @pointList.push @arrivalAirport.latlng
  refresh: ->
    @hide()
    @drawPath()
    @show()
  setStyle: (color, weight) ->
    @color = color
    @weight = weight
    @refresh()
  drawPath: ->
    archPos = undefined
    i = undefined
    len = undefined
    mapPath = undefined
    ref = undefined
    @visible = true
    archPos = []
    ref = L.MapPaths.mapPaths
    i = 0
    len = ref.length
    while i < len
      mapPath = ref[i]
      if mapPath != this
        if mapPath.departureAirport.equals(@departureAirport) and mapPath.arrivalAirport.equals(@arrivalAirport)
          archPos[mapPath.archPosition] = true
      i++
    @calculateArch archPos
    @pathLine = new (L.Polyline)(@pointList,
      color: @color
      weight: @weight
      opacity: 0.8
      smoothFactor: 1).on 'click', (e) ->
        pathHandler.click L.MapPaths.getPathByPathLine(e.target._leaflet_id)
    @pathLineDecorator = L.polylineDecorator(@pathLine, patterns: [ {
      offset: '50px'
      repeat: '100px'
      symbol: new (L.Symbol.ArrowHead)(
        pixelSize: 5 * @weight
        pathOptions: color: @color)
    } ])
)

L.mapPath = (flight, map) ->
  new (L.MapPath)(flight, map)

L.MapPaths =
  mapPaths: []
  factors: []
  getPathByPathLine: (pathId) ->
    for path in @mapPaths
      if path.pathLine._leaflet_id is pathId
        return path
    return false
  getLayerGroup: ->
    L.layerGroup @mapPaths
  getFactorById: (id) ->
    factor = undefined
    i = undefined
    len = undefined
    ref = undefined
    ref = @factors
    i = 0
    len = ref.length
    while i < len
      factor = ref[i]
      if factor._id == id
        return factor
      i++
    false
  getMapPathByFactor: (factor) ->
    i = undefined
    len = undefined
    ref = undefined
    tempMapPath = undefined
    ref = @mapPaths
    i = 0
    len = ref.length
    while i < len
      tempMapPath = ref[i]
      if tempMapPath.departureAirport.id == factor['departureAirport']._id and tempMapPath.arrivalAirport.id == factor['arrivalAirport']._id
        return tempMapPath
      i++
    false
  addInitializedPath: (mapPath) ->
    @mapPaths.push mapPath
  addFactor: (id, factor, map) ->
    existingFactor = undefined
    path = undefined
    existingFactor = @getFactorById(id)
    if existingFactor != false
      return @getMapPathByFactor(existingFactor)
    factor._id = id
    path = @getMapPathByFactor(factor)
    if path != false
      path.totalSeats += factor['totalSeats']
    else if path == false
      path = new (L.MapPath)(factor, map).addTo(map)
      path.totalSeats = factor['totalSeats']
    @factors.push factor
    path.flights++
    path
  removeFactor: (id) ->
    factor = undefined
    path = undefined
    ref = undefined
    factor = @getFactorById(id)
    if factor == false
      return false
    @factors.splice @factors.indexOf(factor), 1
    path = @getMapPathByFactor(factor)
    path.totalSeats -= factor['totalSeats']
    path.flights--
    if path.flights is 0
      path.arrivalAirport.hide()
      path.departureAirport.hide()
      path.hide()
      return false
    else
      path.show()
      {
        'path': path
        'factor': factor
      }
  updateFactor: (id, newFactor, map) ->
    oldFactor = @getFactorById(id)
    path = @getMapPathByFactor(oldFactor)
    path.totalSeats -= oldFactor['totalSeats']
    path.totalSeats += newFactor['totalSeats']
    #TODO: What else needs to be updated?  seats_week?
    return path
  showPath: (mapPath) ->
    mapPath.show()
  hidePath: (mapPath) ->
    mapPath.hide()
  hideAllPaths: ->
    i = undefined
    len = undefined
    path = undefined
    ref = undefined
    results = undefined
    ref = @mapPaths
    results = []
    i = 0
    len = ref.length
    while i < len
      path = ref[i]
      results.push path.hide()
      i++
    results
  showAllPaths: ->
    i = undefined
    len = undefined
    path = undefined
    ref = undefined
    results = undefined
    ref = @mapPaths
    results = []
    i = 0
    len = ref.length
    while i < len
      path = ref[i]
      results.push path.show()
      i++
    results
  hideAllNodes: ->
    i = undefined
    len = undefined
    node = undefined
    ref = undefined
    results = undefined
    ref = L.MapNodes.mapNodes
    results = []
    i = 0
    len = ref.length
    while i < len
      node = ref[i]
      results.push node.hide()
      i++
    results
  showAllNodes: ->
    L.MapNodes.showAllNodes()
  hideBetween: (mapNodeA, mapNodeB) ->
    i = undefined
    len = undefined
    mapPath = undefined
    ref = undefined
    results = undefined
    ref = @mapPaths
    results = []
    i = 0
    len = ref.length
    while i < len
      mapPath = ref[i]
      if mapPath.departureAirport == mapNodeA and mapPath.arrivalAirport == mapNodeB
        mapPath.hide()
      if mapPath.departureAirport == mapNodeB and mapPath.arrivalAirport == mapNodeA
        results.push mapPath.hide()
      else
        results.push undefined
      i++
    results
L.MapNode = L.Path.extend(
  visible: false
  latlng: null
  city: null
  state: null
  stateName: null
  country: null
  countryName: null
  globalRegion: null
  WAC: null
  notes: null
  code: null
  name: null
  key: null
  map: null
  marker: null
  onAdd: (map) ->
    if @marker != null
      @marker.addTo map
    return
  onRemove: (map) ->
    map.removeLayer @marker
    return
  initialize: (node, map) ->
    i = undefined
    len = undefined
    ref = undefined
    results = undefined
    @map = map
    @id = node['_id']
    @name = node.name
    @city = node.city
    @state = node.state
    @stateName = node.stateName
    @country = node.country
    @countryName = node.countryName
    @globalRegion = node.globalRegion
    @notes = node.notes
    @WAC = node.WAC
    @key = node.key
    @latlng = new (L.LatLng)(node.loc.coordinates[1], node.loc.coordinates[0])
    if !L.MapNodes.contains(this)
      @marker = L.marker(@latlng)
      @marker.on 'click', (e) ->
        nodeHandler.click L.MapNodes.getNodeByMarker(e.target._leaflet_id)
      L.MapNodes.addInitializedNode this
    else
      ref = L.MapNodes.mapNodes
      results = []
      i = 0
      len = ref.length
      while i < len
        node = ref[i]
        if node.id == @id
          results.push @marker = node.marker
        else
          results.push undefined
        i++
      results
  equals: (otherNode) ->
    otherNode.latlng.lat == @latlng.lat and otherNode.latlng.lng == @latlng.lng
  hide: ->
    @visible = false
    @map.removeLayer @marker
  show: ->
    @visible = true
    @marker = L.marker(@latlng)
)
L.MapNodes =
  selectedNode: null
  mapNodes: []
  getNodeByMarker: (markerId) ->
    for node in @mapNodes
      if node.marker._leaflet_id is markerId
        return node
    return false
  getLayerGroup: ->
    L.layerGroup @mapNodes
  addInitializedNode: (node) ->
    @mapNodes.push node
  nodeClickEvent: (node) ->
    alert node.id
  addNode: (mapNode) ->
    exists = undefined
    i = undefined
    len = undefined
    ref = undefined
    tempMapNode = undefined
    exists = false
    ref = @mapNodes
    i = 0
    len = ref.length
    while i < len
      tempMapNode = ref[i]
      if tempMapNode.key == mapNode['_id']
        exists = true
      i++
    if !exists
      return new (L.MapNode)(mapNode, @map)
    return
  removeNode: (id) ->
    i = undefined
    len = undefined
    ref = undefined
    tempMapNode = undefined
    ref = @mapNodes
    i = 0
    len = ref.length
    while i < len
      tempMapNode = ref[i]
      if tempMapNode.id == id
        tempMapNode.hide()
        @mapNodes.splice @mapNodes.indexOf(tempMapNode), 1
        return
      i++
    return
  updateNode: (mapNode) ->
    i = undefined
    len = undefined
    ref = undefined
    results = undefined
    tempMapNode = undefined
    ref = @mapNodes
    results = []
    i = 0
    len = ref.length
    while i < len
      tempMapNode = ref[i]
      if tempMapNode.id == tempMapNode['_id']
        tempMapNode.hide()
        tempMapNode.initialize mapNode, @map
        results.push tempMapNode.show()
      else
        results.push undefined
      i++
    results
  contains: (node) ->
    i = undefined
    len = undefined
    mapNode = undefined
    mapNodesContains = undefined
    ref = undefined
    mapNodesContains = false
    ref = @mapNodes
    i = 0
    len = ref.length
    while i < len
      mapNode = ref[i]
      if mapNode.id == node.id
        mapNodesContains = true
      i++
    mapNodesContains
  mapNodeCount: ->
    @mapNodes.length
  hideNode: (node) ->
    node.hide()
  showNode: (node) ->
    node.show()
  hideAllNodes: ->
    i = undefined
    len = undefined
    node = undefined
    ref = undefined
    results = undefined
    ref = @mapNodes
    results = []
    i = 0
    len = ref.length
    while i < len
      node = ref[i]
      results.push node.hide()
      i++
    results
  showAllNodes: ->
    i = undefined
    len = undefined
    node = undefined
    ref = undefined
    results = undefined
    ref = @mapNodes
    results = []
    i = 0
    len = ref.length
    while i < len
      node = ref[i]
      results.push node.show()
      i++
    results

L.mapNode = (node, map) ->
  new (L.MapNode)(node, map)
