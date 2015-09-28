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
  mapper = require '../../src/grits-net-mapper'
  it 'should do nothing', ->
    return
