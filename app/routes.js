const express = require('express'),
      Stock = require('./models/Stock.js'),
      stockSearch = require('./stockConfig.js');

const router = express.Router();


// Search for a stocks info via the Yahoo Finance Api
router.get('/searchStock/:stock', (req, res) => {
    stockSearch(req.params.stock)
        .then(stockHistory => {
            res.send(stockHistory.map(point => ({
                date: point.date,
                value: point.close,
                symbol: point.symbol
              })
            ));
        })
        .catch(e => res.send(e));
});

// Read from and write to the stock database
router.route('/stocks')
    .get((req, res) => {
        Stock.find((err, stocks) => err ? res.send(err) : res.json(stocks));
    })
    .post((req, res) => {
        let stock = new Stock();

        stock.symbol = req.body.symbol;
        stock.date = req.body.date;
        stock.value = req.body.value;

        stock.save(err => err ? res.send(err) : res.end());
    });

// Remove a poll from the database
router.delete('/stocks/:stockId', (req, res) => {
    Stock.remove({_id: req.params.stockId}, err => err ? res.send(err) : res.end());
});


module.exports = router;
