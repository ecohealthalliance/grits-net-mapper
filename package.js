Package.describe({
  name: 'treyyoder:grits-net-mapper',
  version: '0.0.1',
  summary: '',
  git: '',  
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.3');  
  api.use('coffeescript');
  api.use('fuatsengul:leaflet', 'client');
  api.addFiles('leafnav.js', ['client']);
  api.addFiles('grits-net-mapper.coffee', ['client']);
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use('treyyoder:grits-net-mapper');
  api.addFiles('grits-net-mapper-tests.js');
});
