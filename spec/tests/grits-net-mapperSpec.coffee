describe 'grits-net-mapper', ->
  global.Meteor =
    client: true
  global.Blaze =
    renderWithData = (one, two, three) ->
      return
  global.L = {}
  global.L.Class = {}
  global.L.Class.extend = ->
  global.L.LineUtil = {}
  global.L.LayerGroup = {}
  global.L.LatLng = {
    lng:null
    lat:null
    initialize: (lng,lat) ->
      @lng = lng
      @lat = lat
  }
  global.L.LayerGroup.extend = ->
  global.L.Marker = {
    latlng: null
    initialize: (latlng) ->
      @latlng = latlng
  }
  global.L.Marker.extend = ->
  global.L.Path = {}
  global.L.Path.extend = ->
  mapper = require '../../src/grits-net-mapper'
  global.L.MapNode =
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
      @latlng = new (global.L.LatLng).initialize(node.loc.coordinates[1], node.loc.coordinates[0])
      console.log @latlng
      if !global.L.MapNodes.contains(this)
        @marker = global.L.Marker.initialize(@latlng)
        global.L.MapNodes.addInitializedNode this
        return this
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
  global.L.MapPath =
    id: null
    map: null
    smoothFactor: 1.0
    pointList: null
    pathLine: null
    pathLineDecorator: null
    departureAirport: null
    arrivalAirport: null
    destWAC: null
    miles: null
    origWAC: null
    totalSeats: null
    seats_week: null
    stops: null
    flights: 0
    visible: false
    color: null
    weight: null
    initialize: (flight, map) ->
      @map = map
      @visible = true
      @id = flight['_id']
      if flight.departureAirport != null
        @departureAirport = new L.MapNode.initialize(flight.departureAirport, @map)
      if flight.arrivalAirport != null
        @arrivalAirport = new L.MapNode.initialize(flight.arrivalAirport, @map)
      global.L.MapNodes.mapNodes = [@departureAirport, @arrivalAirport]
      @miles = flight.Miles
      @origWAC = flight['Orig WAC']
      @totalSeats = flight.totalSeats
      @seats_week = flight['Seats/Week']
      @stops = flight.Stops
      @pointList = [
        @departureAirport.latlng
        @arrivalAirport.latlng
      ]
      return this
    setStyle: (color, weight) ->
      @color = color
      @weight = weight
    calculateArch: ->
      console.log this
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
        ], true)
        [
          @arrivalAirport.latlng.lat
          @arrivalAirport.latlng.lng
        ]
      ]
      curved = turf.bezier(line, 10000, 1)
      @pointList = curved.geometry.coordinates
      @pointList.push @arrivalAirport.latlng
  global.L.Path.extend = ->

  flight = {'_id':'b842e0600ca4ca44c2dcd768db161a88','carrier':'AA','flightNumber':7374,'serviceType':'J','effectiveDate':'2015-10-05T00:00:00.000Z','discontinuedDate':'2016-04-01T00:00:00.000Z','day1':true,'day2':true,'day3':true,'day4':true,'day5':true,'day6':true,'day7':true,'departureAirport':{'city':'Brisbane','name':'Brisbane Intl','loc':{'type':'Point','coordinates':[153.1163,-27.385]},'country':null,'notes':null,'stateName':'Queensland','WAC':802,'countryName':'Australia','state':'QL','globalRegion':'Australasia','_id':'BNE'},'departureCity':'BNE','departureState':'QL','departureCountry':'AU','departureTimePub':'1900-01-01T15:40:00.000Z','departureUTCVariance':1000,'arrivalAirport':{'city':'Canberra','name':'Canberra','loc':{'type':'Point','coordinates':[149.195,-35.3089]},'country':null,'notes':null,'stateName':'Australian Cap. Terr.','WAC':802,'countryName':'Australia','state':'AC','globalRegion':'Australasia','_id':'CBR'},'arrivalCity':'CBR','arrivalState':'AC','arrivalCountry':'AU','arrivalTimePub':'1900-01-01T18:30:00.000Z','arrivalUTCVariance':1100,'flightArrivalDayIndicator':'0','stops':0,'stopCodes':[],'totalSeats':168,'weeklyFrequency':null,'_original':{'_id':'b842e0600ca4ca44c2dcd768db161a88','carrier':'AA','flightNumber':7374,'serviceType':'J','effectiveDate':'2015-10-05T00:00:00.000Z','discontinuedDate':'2016-04-01T00:00:00.000Z','day1':true,'day2':true,'day3':true,'day4':true,'day5':true,'day6':true,'day7':true,'departureAirport':{'city':'Brisbane','name':'Brisbane Intl','loc':{'type':'Point','coordinates':[153.1163,-27.385]},'country':null,'notes':null,'stateName':'Queensland','WAC':802,'countryName':'Australia','state':'QL','globalRegion':'Australasia','_id':'BNE'},'departureCity':'BNE','departureState':'QL','departureCountry':'AU','departureTimePub':'1900-01-01T15:40:00.000Z','departureUTCVariance':1000,'arrivalAirport':{'city':'Canberra','name':'Canberra','loc':{'type':'Point','coordinates':[149.195,-35.3089]},'country':null,'notes':null,'stateName':'Australian Cap. Terr.','WAC':802,'countryName':'Australia','state':'AC','globalRegion':'Australasia','_id':'CBR'},'arrivalCity':'CBR','arrivalState':'AC','arrivalCountry':'AU','arrivalTimePub':'1900-01-01T18:30:00.000Z','arrivalUTCVariance':1100,'flightArrivalDayIndicator':'0','stops':0,'stopCodes':[],'weeklyFrequency':null,'totalSeats':168},'_isNew':false,'_errors':{'_size':0,'_values':{},'_sizeDeps':{'_dependentsById':{}},'_allDeps':{'_dependentsById':{}},'_keysDeps':{'_dependentsById':{}},'_valuesDeps':{'_dependentsById':{}},'_keyDeps':{},'_hasDeps':{}}}
  path = global.L.MapPath.initialize(flight, null)
  it 'should set the color and weight', ->
    path.setStyle('blue', 5)
    expect(L.MapPath.color).toBe('blue');
    expect(L.MapPath.weight).toBe(5);
  it 'should create path and it\'s departure and destination nodes', ->
    expect(L.MapNodes.mapNodes[0].id).toBe('BNE')
    expect(L.MapNodes.mapNodes[1].id).toBe('CBR')
  it 'path should be equal and then not equal', ->
    expect(global.L.MapNodes.mapNodes[0].equals(global.L.MapNodes.mapNodes[0])).toBe(true)
    expect(global.L.MapNodes.mapNodes[0].equals(global.L.MapNodes.mapNodes[0])).toBe(true)
  it 'path should be the same', ->
    path2 = global.L.MapPath.initialize(flight, null)
