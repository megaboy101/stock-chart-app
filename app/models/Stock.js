const mongoose = require('mongoose');

module.exports = mongoose.model('Stock', new mongoose.Schema({
    symbol: String,
    date: String,
    value: Number
}));
