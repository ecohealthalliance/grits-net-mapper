Package.describe({
  name: 'grits:grits-net-mapper',
  version: '0.0.1',
  summary: '',
  git: '',
  documentation: 'README.md',
});
Package.onUse(function configureApi(api) {
  api.versionsFrom('1.1.0.3');
  api.use('coffeescript');
  api.use('yauh:turfjs-client', 'client');
  api.use('fuatsengul:leaflet', 'client');
  api.addFiles('L.LineUtil.PolylineDecorator.js', [ 'client' ]);
  api.addFiles('L.Symbol.js', [ 'client' ]);
  api.addFiles('L.PolylineDecorator.js', [ 'client' ]);
  api.addFiles('grits-net-mapper.coffee', [ 'client' ]);
});
Package.onTest(function configureApi(api) {
  api.use('tinytest');
  api.use('coffeescript');
  api.use('grits:grits-net-mapper');
  api.addFiles('grits-net-mapper-tests.coffee');
});
