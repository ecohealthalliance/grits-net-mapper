Package.describe({
  name: 'grits:grits-net-mapper',
  version: '0.2.2',
  summary: '',
  git: 'https://github.com/ecohealthalliance/grits-net-mapper',
  documentation: 'README.md',
});
Package.onUse(function configureApi(api) {
  api.versionsFrom('1.1.0.3');
  api.use([
    'underscore',
    'coffeescript',
    'jparker:crypto-md5',
    'bevanhunt:leaflet@0.3.18'
  ]);
  api.addFiles([
    'src/grits_node.coffee',
    'src/grits_marker.coffee',
    'src/grits_path.coffee',
    'src/grits_layer.coffee',
    'src/grits_map.coffee'
  ], 'client');
  api.addAssets([
    'images/marker-icon-282828.svg',
    'images/marker-icon-383838.svg',
    'images/marker-icon-484848.svg',
    'images/marker-icon-585858.svg',
    'images/marker-icon-787878.svg',
    'images/marker-icon-686868.svg',
    'images/marker-icon-888888.svg',
    'images/marker-icon-989898.svg',
    'images/marker-icon-A8A8A8.svg',
    'images/marker-icon-B8B8B8.svg'
  ], 'client');
  api.export([
    'GritsNode',
    'GritsMarker',
    'GritsPath',
    'GritsLayer',
    'GritsMap'
  ], 'client');
});
