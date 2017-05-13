/* eslint-disable no-console */
const path = require('path'),
      express = require('express'),
      mongoose = require('mongoose'),
      bodyParser = require('body-parser'),
      sockets = require('./sockets.js');


const port = process.env.PORT || 3000,
      app = express(),
      server = sockets(app);

mongoose.connect(`mongodb://${process.env.MLAB_USERNAME}:${process.env.MLAB_PASSWORD}@ds153730.mlab.com:53730/nightlife-app`);


app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

app.use(express.static('dist'));


app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../dist/index.html'));
});


server.listen(port, (err) => {
    if (err)
        console.log(err);

    console.log('Production server running on port: ' + port);
});
