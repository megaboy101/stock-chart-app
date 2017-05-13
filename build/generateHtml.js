/*eslint-disable no-console*/
const fs = require('fs'),
      cheerio = require('cheerio');

fs.readFile('src/index.html', 'utf8', (err, markup) => {
    const $ = cheerio.load(markup);
    
    if (err)
        console.log(err);

    $('head').prepend('<link rel="stylesheet" href="style.css">');

    fs.writeFile('dist/index.html', $.html(), 'utf8', err => (
        err ?
            console.log(err) :
            console.log('HTML file written to /dist')
    ));
});
