require('dotenv').config();
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');
const webpack = require('webpack');

module.exports = {
  entry: ['./src/elm/Stylesheets.elm', './src/main.js'],
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
        exclude: [/elm-stuff/, /node_modules/, /Stylesheets\.elm$/],
        use: [
          'elm-hot-loader',
          {
            loader: 'elm-webpack-loader',
            options: {
              debug: process.env.NODE_ENV !== 'production',
            },
          },
        ],
      },
      {
        test: /Stylesheets\.elm$/,
        use: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'elm-css-webpack-loader'],
        })
      },
    ],
  },
  plugins: [
    new webpack.EnvironmentPlugin(['SOUNDCLOUD_CLIENT_ID']),
    new ExtractTextPlugin('style.css'),
  ],
};
