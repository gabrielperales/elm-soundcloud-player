require('dotenv').config();
const path = require('path');
const webpack = require('webpack');

module.exports = {
  mode: process.env.NODE_ENV === 'production' ? 'production' : 'development',
  devtool: 'source-map',
  entry: './src/main.js',
  output: {
    filename: 'js/bundle.js',
  },
  devServer: {
    inline: true,
    historyApiFallback: true,
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-webpack-loader',
            options: {
              debug: process.env.NODE_ENV !== 'production',
            },
          },
        ],
      },
    ],
  },
  plugins: [new webpack.EnvironmentPlugin(['SOUNDCLOUD_CLIENT_ID'])],
};
