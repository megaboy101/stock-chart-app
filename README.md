# TODO List

1. Write back-end code <<=
  - Write up database to save what stock quotes are currently presented
  - Write up Api routes to database and Yahoo finance
  - Write up WebSocket connections
2. Write Elm code
  - Set up outline for model/view/update <<=
  - Create data model <<=
  - Create update functions
  - Create view model
  - Setup api Tasks
  - Setup ports
  - Write tests
3. Write front-end code
  - Create Stock chart
  - Integrate chart to Elm
  - Create app theming
  - Write css styles
4. Write up production build code
  - Setup NPM scripts
  - Setup production Webpack build
  - Setup production HTML file
  - Optimize for Heroku
  - Deploy!


# API docs

## Routes

### GET /api/searchStock/:stock

Given a stock symbol (ex: GOOG) as the extension, returns an api response with the resulting stock
`
  {
    symbol: String
    points: [{
      date: String,
      value: Float
    }]
  }
`

### GET /api/stocks

Returns an array of all stock information currently stored in the database.

### POST /api/stocks

Given a stocks 'symbol', 'date', and 'value' as request body keys, saves a stock to the database

### DELETE /api/stocks/:stockId

Given a stocks database ID provided in the URL, deletes a stock from the database

## WebSockets

### connection

On connection to the WebSocket, sends a server message containing all stocks currently in the database

### message: Stock symbol

When a message is picked up by the server, and its 'action' is 'ADD', searches for the stock symbol and does 2 things with the data. First, Broadcasts the new stock to all clients for real-time update. Second, saves the poll to the database.

### message: No stock symbol

When a message is picked up by the server, and not to 'ADD', will assume the message contains a stocks 'id' and does 2 things. First, broadcasts the stocks id for real-time update. Second, removes the poll from the database.
