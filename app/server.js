var path = require('path'),
    express = require('express'),
    webpack = require('webpack'),
    devMiddleware = require('webpack-dev-middleware'),
    config = require('../webpack.config.dev.js');

const app = express();
const port = 3000;
const compiler = webpack(config);

app.use(devMiddleware(compiler, {
    noInfo: false,
    publicPath: config.output.publicPath
}));


app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../src/index.html'));
});


app.listen(port, err => {
    if (err)
        console.log(err);
    console.log('App started on port: ' + port);
});
