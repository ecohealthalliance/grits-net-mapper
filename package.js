Package.describe({
  name: 'grits:grits-net-mapper',
  version: '0.2.2',
  summary: '',
  git: 'https://github.com/ecohealthalliance/grits-net-mapper',
  documentation: 'README.md',
});
Package.onUse(function configureApi(api) {
  api.versionsFrom('1.1.0.3');
  api.addFiles('./lib/grits-net-mapper.js', 'client');
});
