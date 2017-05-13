var path = require('path');

module.exports = {
    entry: path.resolve(__dirname, 'src/index.js'),

    output: {
        path: __dirname + '/dist',
        publicPath: '/',
        filename: 'bundle.js'
    },

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

    target: 'web',
    devtool: 'cheap-module-eval-source-map'
};
