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
  global.L.LayerGroup.extend = ->
  global.L.Marker = {}
  global.L.Marker.extend = ->
  global.L.Path = {}
  global.L.Path.extend = ->
  global.L.Map = {}
  global.L.Map.extend = ->
  layer = require '../../src/grits_layer'
  marker = require '../../src/grits_marker'
  map = require '../../src/grits_map'
  node = require '../../src/grits_node'
  path = require '../../src/grits_path'
  it 'should do nothing', ->
    return
