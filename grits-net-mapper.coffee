if Meteor.isClient
  'use strict'
  if typeof L != 'undefined'
    L.MapPath =  L.Path.extend(
      id: null
      map: null
      smoothFactor: 1.0
      pointList: null      
      pathLine: null      
      origin: null
      destination: null
      destWAC: null      
      miles: null      
      origWAC: null
      seats: null
      seats_week: null
      stops: null   
      flights: 0      
      visible: false        
      onAdd: (map) ->
        this.show()
        return
      show: () ->
        @visible = true
        @pathLine.addTo(@map) if @pathLine isnt null
        @origin.addTo(@map) if @origin isnt null and @origin.visible is false
        @destination.addTo(@map) if @destination isnt null and @destination.visible is false
        return
      hide: () ->
      	@visible = false
      	@map.removeLayer @pathLine if @pathLine isnt null      	
      	return
      update: (flight) ->        
        @origin = new L.MapNode(flight.Orig, @map) if flight.origin?
        @destination = new L.MapNode(flight.Dest, @map) if flight.Dest?        
        @miles= flight.Miles if flight.Miles?        
        @origWAC = flight['Orig WAC'] if flight['Orig WAC']
        @seats = flight.Seats if flight.Seats?
        @seats_week= flight['Seats/Week'] if flight['Seats/Week']?        
        this.setPopup()
        return
      initialize: (flight, map) ->
        @map = map
        @visible = true
        @id = flight['_id']       
        @origin = new L.MapNode(flight.Orig, @map) if flight.Orig?
        @destination = new L.MapNode(flight.Dest, @map) if flight.Dest?        
        @miles= flight.Miles        
        @origWAC = flight['Orig WAC']
        @seats = flight.Seats
        @seats_week= flight['Seats/Week']
        @stops = flight.Stops
        @pointList = [@origin.latlng, @destination.latlng]
        L.MapPaths.addInitializedPath(this)
        this.drawPath()
      midPoint:(points, ud) ->
        midPoint = []
        latDif = Math.abs(points[0].lat - (points[1].lat))
        if points[0].lat > points[1].lat
          if ud
            midPoint[0] = points[1].lat + latDif/4
          else
            midPoint[0] = points[0].lat - latDif/4
        else
          if ud
            midPoint[0] = points[1].lat + latDif/4
          else
            midPoint[0] = points[1].lat - latDif/4
        midPoint[1] = (points[0].lng + points[1].lng) / 2
        midPoint
      calculateArch:()->
        line =
          'geometry':
            'coordinates': [
              [@origin.latlng.lat, @origin.latlng.lng]
              @midPoint([@origin.latlng, @destination.latlng], true)
              [@destination.latlng.lat, @destination.latlng.lng]
              ]
        curved = turf.bezier(line, 10000, 1)
        @pointList = curved.geometry.coordinates      
      refresh: () ->
        this.setPopup()
        this.hide()
        this.drawPath()
        this.show()      
      setPopup: () ->
        popup = new L.popup()
        div = L.DomUtil.create("div","")       
        Blaze.renderWithData(Template.pathDetails, this, div);
        popup.setContent(div)
        @pathLine.bindPopup(popup);        
      setStyle: (color, weight) ->
        @color = color
        @weight = weight
      drawPath: () ->        
        @visible = true              
        #is there an existing path displayed (visible) between the path nodes?
        archPos = []
        for mapPath in L.MapPaths.mapPaths
          if mapPath isnt this
            if (mapPath.origin.equals @origin) and (mapPath.destination.equals @destination)
              archPos[mapPath.archPosition]=true           
        this.calculateArch(archPos)
        @pathLine = new (L.Polyline)(
          @pointList
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
      factors: []
      getLayerGroup: () ->        
        return L.layerGroup(@mapPaths)
      getFactorById:(id)->
        for factor in @factors
          if factor._id is id
            return factor
        return false
      getMapPathByFactor:(factor)->
        for tempMapPath in @mapPaths
          if tempMapPath.origin.id is factor["Orig"]._id and tempMapPath.destination.id is factor["Dest"]._id
            return tempMapPath
        return false
      addInitializedPath: (mapPath) ->
        @mapPaths.push(mapPath)
      addFactor: (id, factor, map) ->
        if @getFactorById(id) isnt false
          return
        factor._id = id
        path = @getMapPathByFactor(factor)
        if path isnt false
          path.seats += factor["Seats"]
          path.flights++
          path.refresh()
          @factors.push factor          
        else if path is false
          path = new L.MapPath(factor, map).addTo(map)
          path.seats = factor["Seats"]
          path.flights++
          path.refresh()
          @factors.push factor
        return path
      removeFactor: (id) ->
        factor = @getFactorById(id)
        if factor is false
          return false
        @factors.splice(@factors.indexOf(factor), 1)
        path = @getMapPathByFactor(factor)
        path.seats -= factor["Seats"]
        path.flights--                  
        path.hide()        
        if path.flights is 0
          removeDest = true
          removeOrig = true
          o1 = path.origin
          d1 = path.destination
          for tempMapPath in @mapPaths
            o2 = tempMapPath.origin
            d2 = tempMapPath.destination
            if ( o2.id is o1.id or o1.id is d2.id) and tempMapPath isnt path
              removeOrig = false
            if ( d2.id is d1.id or d1.id is o2.id) and tempMapPath isnt path
              removeDest = false
          if removeDest
            path.destination.hide()              
            L.MapNodes.mapNodes.splice(L.MapNodes.mapNodes.indexOf(path.destination), 1)
          if removeOrig
            path.origin.hide()
            L.MapNodes.mapNodes.splice(L.MapNodes.mapNodes.indexOf(path.origin), 1)
          @mapPaths.splice(@mapPaths.indexOf(path), 1)
          return false
        else
          path.show()         
          return {"path":path,"factor":factor}
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
        node.hide() for node in L.MapNodes.mapNodes
      showAllNodes:() ->
        L.MapNodes.showAllNodes()
      hideBetween: (mapNodeA, mapNodeB) ->
        for mapPath in @mapPaths
          if mapPath.origin is mapNodeA and mapPath.destination is mapNodeB
            mapPath.hide()
          if mapPath.origin is mapNodeB and mapPath.destination is mapNodeA
            mapPath.hide()

    L.MapNode = L.Path.extend(
      visible: false
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
        @marker.addTo(map) if @marker isnt null
        return
      onRemove: (map) ->
        map.removeLayer(@marker)
        return
      setPopup: () ->
        popup = new L.popup()
        div = L.DomUtil.create("div","")       
        Blaze.renderWithData(Template.nodeDetails, this, div);
        popup.setContent(div)
        @marker.bindPopup(popup);        
      initialize: (node, map) ->
        @map = map        
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
        else
          for node in L.MapNodes.mapNodes
            if node.id is @id
              @marker = node.marker           
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
