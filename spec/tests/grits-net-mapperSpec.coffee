describe 'grits-net-mapper', ->
  global.Meteor =
    client: true
  global.Blaze =
    renderWithData = (one, two, three) ->
      return
  mapper = require '../../grits-net-mapper'
  it 'should do nothing', ->
    return
