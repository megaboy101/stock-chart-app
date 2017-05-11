// Import elm code
var Elm = require('./Main.elm');
var app = Elm.Main.fullscreen();

// Import custom css
require('./style.css');

// Import Chart code
var Chartist = require('chartist');
require('chartist/dist/chartist.min.css');
var buildChart = require('./chartConfig.js');



app.ports.loadChart.subscribe( stocks => buildChart(Chartist, stocks) );
