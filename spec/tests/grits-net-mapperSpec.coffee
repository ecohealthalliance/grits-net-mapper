describe 'grits-net-mapper', ->
  global.Meteor =
    client: true
  global.Blaze =
    renderWithData = (one, two, three) ->
      return
  mapper = require '../../src/grits-net-mapper'
  it 'should do nothing', ->
    return
