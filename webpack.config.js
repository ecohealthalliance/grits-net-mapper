var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    './src/grits_layer',
    './src/grits_map',
    './src/grits_marker',
    './src/grits_node',
    './src/grits_path'
  ],
  devtool: "eval",
  debug: true,
  output: {
    path: path.join(__dirname, "lib"),
    filename: 'grits-net-mapper.js'
  },
  resolveLoader: {
    modulesDirectories: ['node_modules']
  },
  resolve: {
    extensions: ['', '.js', '.cjsx', '.coffee']
  },
  module: {
    loaders: [{
      test: /\.coffee$/,
      loader: 'coffee'
    }]
  }
};
