var moment = require('moment');

module.exports = (Chartist, stocks) => {
  var series = [];
  for (var i = 0; i < stocks.length; i++) {
      series.push({
          name: stocks[i].symbol,
          data: stocks[i].history.map(point => ({
              x: new Date(point.date),
              y: point.value
          }))
      });
  }


  var chart = new Chartist.Line('#chart', { series: series },
    {
        axisX: {
            type: Chartist.FixedScaleAxis,
            divisor: 12,
            labelInterpolationFnc: function(value) {
                return moment(value).format('MMM');
            }
        },
        showPoint: false,
        showArea: true
    });

    chart.on('draw', function(data) {
    if(data.type === 'line' || data.type === 'area') {
      data.element.animate({
        d: {
          begin: 600 * data.index,
          dur: 600,
          from: data.path.clone().scale(1, 0).translate(0, data.chartRect.height()).stringify(),
          to: data.path.clone().stringify(),
          easing: Chartist.Svg.Easing.easeOutQuint
        }
      });
    }
  });
};
