// Import elm code
var Elm = require('./Main.elm');
var app = Elm.Main.fullscreen();

// Import css
require('tachyons');
require('./style.css');

// Import Chart configs
var Chartist = require('chartist');
require('chartist/dist/chartist.min.css');
require('./chartPluginConfig.js')(Chartist);
var buildChart = require('./chartConfig.js');


// JavaScript subscribes to updates from Elm, updates chart when new data is sent
app.ports.loadChart.subscribe( stocks => buildChart(Chartist, stocks) );
