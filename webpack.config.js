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
    historyApiFallback: true,
  },
  module: {
    rules: [{
      test: /\.elm$/,
      exclude: [/elm-stuff/, /node_modules/],
      loader: 'elm-webpack-loader' +
        (process.env.NODE_ENV !== 'production' ? '?+debug' : ''),
    }],
  },
  plugins: [
    new webpack.EnvironmentPlugin(['SOUNDCLOUD_CLIENT_ID']),
  ],
};
