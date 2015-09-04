if Meteor.isClient
  'use strict'
  if typeof L != 'undefined'
    L.MapPath =  L.Path.extend(
      id: null
      map: null
      smoothFactor: 1.0
      pointList: null
      IDLpointList: null
      pathLine: null
      IDLpathLine: null
      origin: null
      destination: null
      destWAC: null
      alliance: null
      arrFlag: null
      arrTerm: null
      arrTime: null
      blockMins: null
      date: null
      depTerm: null
      depTime: null
      equip: null
      flight: null
      miles: null
      mktgAl: null
      opsAl: null
      ops_day: null
      ops_week: null
      origWAC: null
      seats: null
      seats_week: null
      stops: null      
      visible: false
      origin_terminal: null
      destination_terminal: null
      archPosition: 0 #defines the arch position for drawing the path on a curve to avoid path overlap
      onAdd: (map) ->
        @pathLine.addTo(map)
        if @IDLpathLine isnt null
        	@IDLpathLine.addTo(map)
      show: () ->
        @pathLine.addTo(@map) if @pathLine isnt null
        @IDLpathLine.addTo(@map) if @IDLpathLine isnt null         	
      hide: () ->
      	@visible = false
      	@map.removeLayer @pathLine if @pathLine isnt null
      	@map.removeLayer @IDLpathLine if @IDLpathLine isnt null
      	#L.MapPaths.removePath(this)
      	#^removes the current MapPath from the set of MapPaths  
      update: (flight) ->
        @alliance = flight.Alliance
        @arrFlag = flight['Arr Flag']
        @arrTerm = flight['Arr Term']
        @arrTime = flight['Arr Time']
        @blockMins = flight['Block Mins']
        @arrTime = flight['Arr Time']
        @arrTime = flight['Arr Time']
        @origin = new L.MapNode(flight.Orig, @map) if flight.Orig?
        @destination = new L.MapNode(flight.Dest, @map) if flight.Dest?
        @blockMins= flight['Block Mins']
        @date= flight.Date
        @depTerm= flight['Dep Term']
        @depTime= flight['Dep Time']
        @equip= flight.Equip
        @flight= flight.Flight
        @miles= flight.Miles
        @mktgAl= flight['Mktg Al']
        @opsAl= flight['Op Al']
        @ops_day= flight['Ops Day']
        @ops_week = flight['Ops/Week']
        @origWAC = flight['Orig WAC']
        @seats = flight.Seats
        @seats_week= flight['Seats/Week']
        @stops = flight.Stops
        @pointList = [@origin.latlng, @destination.latlng]
        this.setPopup()
        return
      initialize: (flight, map) ->
        @map = map
        @visible = true
        @id = flight['_id']
        @alliance = flight.Alliance
        @arrFlag = flight['Arr Flag']
        @arrTerm = flight['Arr Term']
        @arrTime = flight['Arr Time']
        @blockMins = flight['Block Mins']
        @arrTime = flight['Arr Time']
        @arrTime = flight['Arr Time']
        @origin = new L.MapNode(flight.Orig, @map) if flight.Orig?
        @destination = new L.MapNode(flight.Dest, @map) if flight.Dest?
        @blockMins= flight['Block Mins']
        @date= flight.Date
        @depTerm= flight['Dep Term']
        @depTime= flight['Dep Time']
        @equip= flight.Equip
        @flight= flight.Flight
        @miles= flight.Miles
        @mktgAl= flight['Mktg Al']
        @opsAl= flight['Op Al']
        @ops_day= flight['Ops Day']
        @ops_week = flight['Ops/Week']
        @origWAC = flight['Orig WAC']
        @seats = flight.Seats
        @seats_week= flight['Seats/Week']
        @stops = flight.Stops
        @pointList = [@origin.latlng, @destination.latlng]
        L.MapPaths.addInitializedPath(this)
        this.drawPath()
      calculateArch: (archPos)->
        orgDestDist = Meteor.leafnav.getDistance(@origin.latlng, @destination.latlng, "K")
        #v this works for north south
        pm = @origin.latlng.lng < @destination.latlng.lng or @origin.latlng.lat < @destination.latlng.lat? true : false     
        pts = 100.0
        bng = Math.floor(Meteor.leafnav.getBearing(@origin.latlng, @destination.latlng))
        rbng = Math.ceil(Meteor.leafnav.getBearing(@destination.latlng, @origin.latlng))       
        @archPosition = (archPos.length)
        latArch = 0.0
        lngArch = 0.0
        distBetweenPoints = orgDestDist / pts
        currentPoint = @origin.latlng
        ptCtr = 1
        arcCoords = []
        IDLarcCoords = []        
        arcCoords.push(currentPoint)
        keepDrawing = true
        gain = .10 * @archPosition 
        IDLsplit = false       
        while ptCtr < pts and keepDrawing
          if Meteor.leafnav.getDistance(currentPoint, @destination.latlng) > distBetweenPoints
            if @archPosition isnt 0
              #spread gain across latitude and longitude based on coordinate bearing relation.
              if ptCtr < (pts/2)
                latArch += (gain * ((180-(bng+rbng))/180))
                lngArch += (gain * ((bng+rbng)/180))
              else
                latArch -= (gain * ((180-(bng+rbng))/180))
                lngArch -= (gain * ((bng+rbng)/180))            
            currentPoint = Meteor.leafnav.calculateNewPositionArch(currentPoint, distBetweenPoints, Meteor.leafnav.getBearing(currentPoint, @destination.latlng), latArch*.01, lngArch*.01, pm)
            if currentPoint.lng > 0 and arcCoords[arcCoords.length-1].lng < 0  and currentPoint.lng > 5
              IDLsplit = true
            if currentPoint.lng < 0 and arcCoords[arcCoords.length-1].lng > 0 and currentPoint.lng < -5
              IDLsplit = true
            if IDLsplit
              IDLarcCoords.push(currentPoint)
            else
              arcCoords.push(currentPoint)
            ptCtr++
          else
            keepDrawing = false
        if IDLsplit                             
          IDLarcCoords.push(@destination.latlng)
        else
          arcCoords.push(@destination.latlng)
        @pointList = arcCoords
        @IDLpointList = IDLarcCoords
      setPopup: () ->
        popup = new L.popup()
        div = L.DomUtil.create("div","")       
        Blaze.renderWithData(Template.pathDetails, this, div);
        popup.setContent(div)
        @pathLine.bindPopup(popup);
        @IDLpathLine.bindPopup(popup) if @IDLpathLine isnt null
      setStyle: () ->
        @color = '#'+Math.floor(Math.random()*16777215).toString(16)
        @weight = Math.floor(Math.random() * 5) + 5  
      drawPath: () ->
        this.setStyle()
        @visible = true              
        #is there an existing path displayed (visible) between the path nodes?
        archPos = []
        for mapPath in L.MapPaths.mapPaths
          if mapPath isnt this
            if (mapPath.origin.equals @origin) and (mapPath.destination.equals @destination)
              archPos[mapPath.archPosition]=true
            #if (mapPath.origin.equals @destination) and (mapPath.destination.equals @origin)
            #  archPos[mapPath.archPosition]=true
        this.calculateArch(archPos)              
        @pathLine = new (L.Polyline)(
          @pointList
          color: @color
          weight: @weight
          opacity: 0.8
          smoothFactor: 1)
        if @IDLpointList isnt null
          @IDLpathLine = new (L.Polyline)(
            @IDLpointList
            color: @color
            weight: @weight
            opacity: 0.8
            smoothFactor: 1)            
        this.setPopup() 
      )

    L.mapPath = (flight, map) ->
      new (L.MapPath)(flight, map)

    L.MapPaths =
      mapPaths : []
      getLayerGroup: () ->        
        return L.layerGroup(@mapPaths)           
      mapPathCount : () ->
        @mapPaths.length
      addInitializedPath: (mapPath) ->
        @mapPaths.push(mapPath)
      addPath: (id, mapPath, map) ->
        mapPath._id = id            
        exists = false
        for tempMapPath in @mapPaths
          if tempMapPath.id is mapPath["_id"]
            exists = true
        if !exists
          new L.MapPath(mapPath, map).addTo(map)
      removePath: (id) ->
        for tempMapPath in @mapPaths
          if tempMapPath.id is id
            tempMapPath.hide()            
            @mapPaths.splice(@mapPaths.indexOf(tempMapPath), 1)      
            return  
      updatePath: (id, mapPath, map) ->
        for tempMapPath in @mapPaths
          if tempMapPath.id is id
            tempMapPath.hide()
            tempMapPath.update(mapPath)
            tempMapPath.show()           
      showPath: (mapPath) ->
        mapPath.show()
      hidePath: (mapPath) ->
        mapPath.hide()
      hideAllPaths:() ->
        path.hide() for path in @mapPaths
      showAllPaths:() ->
        path.show() for path in @mapPaths
      hideAllNodes:() ->
        node.hide() for node in L.MapNodes.hideAllNodes()
      showAllNodes:() ->
        L.MapNodes.showAllNodes()
      hideBetween: (mapNodeA, mapNodeB) ->
        for mapPath in @mapPaths
          if mapPath.origin is mapNodeA and mapPath.destination is mapNodeB
            mapPath.hide()
          if mapPath.origin is mapNodeB and mapPath.destination is mapNodeA
            mapPath.hide()

    L.MapNode = L.Path.extend(
      latlng: null
      city: null
      code: null
      country: null
      countryName: null
      globalRegion: null
      name: null
      notes: null
      state: null
      stateName: null
      wac: null
      key: null      
      map: null
      marker: null
      onAdd: (map) ->
        @marker.addTo(map)
      setPopup: () ->
        popup = new L.popup()
        div = L.DomUtil.create("div","")       
        Blaze.renderWithData(Template.nodeDetails, this, div);
        popup.setContent(div)
        @marker.bindPopup(popup);        
      initialize: (node, map) ->
        @map = map
        @visible = true
        @id = node['_id']
        @city = node.City
        @code = node.Code
        @country = node.Country
        @countryName = node['Country Name']
        @globalRegion = node['Global Region']
        @name = node.Name
        @notes = node.Notes
        @state = node.State
        @stateName = node['State Name']
        @wac= node.WAC
        @key= node.key
        @latlng = new L.LatLng(node.loc.coordinates[1],node.loc.coordinates[0])        
        if !L.MapNodes.contains(this)
          @marker = L.marker(@latlng)
          L.MapNodes.addInitializedNode(this)
          this.setPopup()             
      equals: (otherNode) ->
        return (otherNode.latlng.lat is this.latlng.lat) and (otherNode.latlng.lng is this.latlng.lng)
      hide: () ->
      	@visible = false
      	@map.removeLayer @marker
      show: () ->
      	@visible = true
      	@marker = L.marker(@latlng)
      	this.setPopup()   	
      )

    L.MapNodes =
      mapNodes : []
      getLayerGroup: () ->
        return L.layerGroup(@mapNodes)         
      addInitializedNode : (node) ->
        @mapNodes.push(node)
      addNode: (mapNode) ->
        exists = false
        for tempMapNode in @mapNodes
          if tempMapNode.key is mapNode["_id"]
            exists = true
        if !exists
          new L.MapNode(mapNode, @map)
      removeNode: (id) ->
        for tempMapNode in @mapNodes
          if tempMapNode.id is id
            tempMapNode.hide()          
            @mapNodes.splice(@mapNodes.indexOf(tempMapNode), 1)
            return
      updateNode: (mapNode) ->
        for tempMapNode in @mapNodes
          if tempMapNode.id is tempMapNode["_id"]
            tempMapNode.hide()
            tempMapNode.initialize(mapNode, @map)
            tempMapNode.show()
      contains : (node) ->
      	mapNodesContains = false
      	for mapNode in @mapNodes when mapNode.id is node.id # TODO: change to use mapNode.key
      	    mapNodesContains = true
      	return mapNodesContains
      mapNodeCount : () ->
        @mapNodes.length
      hideNode: (node) ->
        node.hide()
      showNode: (node) ->
        node.show()
      hideAllNodes : () ->
        node.hide() for node in @mapNodes
      showAllNodes : () ->
        node.show() for node in @mapNodes

    L.mapNode = (node, map) ->
      new (L.MapNode)(node, map)

  else
    console.log 'Leaflet Object [L] is missing.'
