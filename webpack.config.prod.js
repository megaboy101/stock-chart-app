const path = require('path'),
      webpack = require('webpack'),
      ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
    entry: path.resolve(__dirname, 'src/index.js'),

    output: {
        path: __dirname + '/dist',
        publicPath: '/',
        filename: 'bundle.js'
    },

    target: 'web',
    devtool: 'sourcemap',

    module: {
        rules: [
            {test: /\.elm$/, exclude: [/node_modules/, /elm-stuff/], use: 'elm-webpack-loader?verbose=true&warn=true'},
            {test: /\.css$/, exclude: /node_modules\/(?!chartist)\/(?!tachyons)/, use: ['style-loader', 'css-loader']},
            {test: /\.(eot|svg|ttf|woff|woff2)$/, exclude: /node_modules\/(?!tachyons)/, use: 'file-loader'}
        ]
    },

    devServer: {
        contentBase: path.resolve(__dirname, 'src')
    },

    plugins: [
      new webpack.optimize.OccurrenceOrderPlugin(),
      new webpack.DefinePlugin({ 'process.env.NODE_ENV': JSON.stringify('production') }),
      new ExtractTextPlugin('style.css'),
      new webpack.optimize.UglifyJsPlugin()
    ]
};
