var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: [
    './src/grits-net-mapper'
  ],
  devtool: "source-map",
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
