const mongoose = require('mongoose');

module.exports = mongoose.model('Stock', new mongoose.Schema({
    symbol: String,
    history: [mongoose.Schema.Types.Mixed]
}));
