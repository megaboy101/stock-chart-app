var moment = require('moment');

module.exports = (Chartist, stocks) => {
  var series = stocks.map(s => ({
    name: s.symbol,
    data: s.history.map(p => ({
      x: new Date(p.date),
      y: p.value
    }))
  }));


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
        showArea: true,
        plugins: [
    Chartist.plugins.ctAxisTitle({
      axisX: {
        axisTitle: 'Months',
        axisClass: 'ct-axis-title f6 avenir b svg-dark-gray',
        offset: {
          x: 0,
          y: 33
        },
        textAnchor: 'middle'
      },
      axisY: {
        axisTitle: 'Value (Day-end in $)',
        axisClass: 'ct-axis-title f6 avenir b svg-dark-gray',
        offset: {
          x: 0,
          y: 14
        },
        textAnchor: 'middle',
        flipTitle: true
      }
    })
  ]
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
