require('dotenv').config()
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const path = require('path')
const webpack = require('webpack')

module.exports = {
  entry: ['tachyons', './src/main.js'],
  output: {
    filename: 'js/bundle.js'
  },
  devServer: {
    inline: true,
    historyApiFallback: true
  },
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader' + (process.env.NODE_ENV !== 'production' ? '?+debug' : '')
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({ fallback: 'style-loader', use: 'css-loader' })
      }
    ]
  },
  plugins: [
    new webpack.EnvironmentPlugin(['SOUNDCLOUD_CLIENT_ID']),
    new ExtractTextPlugin('style.css')
  ]
}
