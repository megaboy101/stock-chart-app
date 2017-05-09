var Elm = require('./Main.elm');
var app = Elm.Main.fullscreen();

// Require elm code before embeding chart
require('amstock3/amcharts/amcharts.js');
require('amstock3/amcharts/serial.js');
require('amstock3/amcharts/amstock.js');
require('amstock3/amcharts/style.css');
var buildChart = require('./chartConfig.js');


buildChart(AmChart);
