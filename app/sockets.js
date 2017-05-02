const WebSocket = require('ws'),
      http = require('http'),
      fetch = require('isomorphic-fetch');

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


module.exports = (app) => {
    const server = http.createServer(app),
          wss = new WebSocket.Server({ server });

    wss.on('connection', client => {
        fetch('/api/stocks')
          .then(res => res.json())
          .then(stocks => client.send(stocks));

        client.on('message', data => {
            const message = JSON.parse(data);
            // For add messages
            if (message.action === 'ADD') {
              fetch('/api/searchStock/' + message.symbol)
                .then(res => res.json())
                .then(stock => {
                    // Run Websocket and fetch synchronously to use Nodes non-blocking IO
                    wss.clients.forEach(client => {
                        if (client.readyState === WebSocket.OPEN)
                            client.send(stock);
                    });

                    fetch('/api/stocks', {
                      method: 'POST',
                      headers: {
                          'Accept': 'application/json',
                          'Content-Type': 'application/json'
                      },
                      body: JSON.stringify({ symbol: message.symbol, date: stock.date, value: stock.value })
                    });
                });
            }
            // For remove messages
            else {
              wss.clients.forEach(client => {
                  if (client.readyState === WebSocket.OPEN)
                      client.send(message._id);
              });

              fetch('/api/stocks/' + message._id, {
                  method: 'DELETE'
              });
            }
        });
    });

    return server;
};
