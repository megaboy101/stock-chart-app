const finance = require('yahoo-finance');

module.exports = function(symbol) {
    return new Promise((resolve, reject) => {
        const d = new Date(),
              currentYear = d.getFullYear(),
              currentMonth = d.getMonth() + 1 < 10 ? '0' + d.getMonth() : d.getMonth(),
              currentDay = d.getDate() < 10 ? '0' + d.getDate() : d.getDate();

        finance.historical({
            symbol: symbol,
            from: `${currentYear - 1}-${currentMonth}-${currentDay}`,
            to: `${currentYear}-${currentMonth}-${currentDay}`,
            period: 'd'
        })
        .then(results => {
            resolve(results);
        })
        .catch(e => {
            reject(e);
        });
    });
};
