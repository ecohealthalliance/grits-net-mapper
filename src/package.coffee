Package.describe
  name: 'grits:grits-net-mapper'
  version: '0.0.1'
  summary: ''
  git: ''
  documentation: 'README.md'
Package.onUse (api) ->
  api.versionsFrom '1.1.0.3'
  api.use 'coffeescript'
  api.use 'fuatsengul:leaflet', 'client'
  api.addFiles 'grits-net-mapper.js', [ 'client' ]
  return
Package.onTest (api) ->
  api.use 'tinytest'
  api.use 'grits:grits-net-mapper'
  api.addFiles 'grits-net-mapper-tests.js'
  return
