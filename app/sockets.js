const WebSocket = require('ws'),
      http = require('http'),
      stockSearch = require('./stockConfig.js'),
      Stock = require('./models/Stock.js');

/*

serverSocket connected...
    Load all stocks saved in database
     |> Send client all Stocks currently in database

    Receive message from client to add stock...
        Search for stock info
          |> Broadcast stock info to all clients
          |> Add stock to database

    Receive message from client to remove stock...
        Broadcast to clear stock from list
        Remove stock from database

*/


module.exports = app => {
    const server = http.createServer(app),
          wss = new WebSocket.Server({ server });

    wss.on('connection', client => {
        Stock.find((err, stocks) => {
          if (err)
            client.send(err);

          client.send(JSON.stringify({
            action: "initLoad",
            body: stocks.map(stock => ({
              symbol: stock.symbol,
              history: stock.history
            }))
          }));
        });

        client.on('message', data => {
            const message = JSON.parse(data);
            // For add messages
            if (message.action === 'search') {
                stockSearch(message.body)
                    .then(stockHistory => {
                        const response = {
                            symbol: stockHistory[0].symbol,
                            history: stockHistory.map(point => ({
                              date: point.date,
                              value: point.close
                            }))
                        };

                        //Run both Websocket broadcast and database update
                        wss.clients.forEach(client => {
                        if (client.readyState === WebSocket.OPEN)
                            client.send(JSON.stringify({
                                action: "addStock",
                                body: response
                            }));
                        });

                        let stock = new Stock();
                        stock.symbol = response.symbol;
                        stock.history = response.history;
                        stock.save(err => {
                          if (err)
                              client.send(err);
                        });
                    });
            }
            // For remove messages
            else {
              wss.clients.forEach(client => {
                  if (client.readyState === WebSocket.OPEN)
                      client.send(JSON.stringify({
                          action: "removeStock",
                          body: message.body
                      }));
              });

              Stock.remove({symbol: message.body}, err => {
                  if (err)
                      client.send(err);
              });
            }
        });
    });

    return server;
};
