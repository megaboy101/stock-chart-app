/* eslint-disable no-console */
const path = require('path'),
      express = require('express'),
      mongoose = require('mongoose'),
      bodyParser = require('body-parser'),
      webpack = require('webpack'),
      devMiddleware = require('webpack-dev-middleware'),
      router = require('./routes.js'),
      config = require('../webpack.config.dev.js'),
      sockets = require('./sockets.js');


const port = 3000,
      app = express(),
      compiler = webpack(config),
      server = sockets(app);


mongoose.connect('mongodb://megaboy101:megaboy101@ds119151.mlab.com:19151/stock-chart-app');

app.use(devMiddleware(compiler, {
    noInfo: false,
    publicPath: config.output.publicPath
}));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use('/api', router);


app.get('*', (req, res) => {
    res.sendFile(path.resolve(__dirname, '../src/index.html'));
});


server.listen(port, err => {
    if (err)
        console.log(err);
    console.log('App started on port: ' + port);
});
