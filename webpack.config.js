require('dotenv').config();
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: './src/main.js',
  output: {
    filename: 'js/bundle.js',
  },
  devServer: {
    inline: true,
  },
  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack-loader',
    }],
  },
  plugins: [
    new webpack.EnvironmentPlugin(['SOUNDCLOUD_CLIENT_ID']),
  ],
};
