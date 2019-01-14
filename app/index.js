var express = require('express');
var app = express();

var cors = require('cors');

app.use(cors());
app.use(express.static('public'));
app.get('/', (req, res) =>{
        res.send('Welcome to Express!' + 'QueryStribg:' + JSON.stringify(req.query) );
});
app.listen(3000, () =>{
        console.log('HTTP Server(3000) is running.');
});

var https = require('https');
var fs = require('fs');
var options = {
  key:  fs.readFileSync('./cert/server.key'),
  cert: fs.readFileSync('./cert/server.crt')
};

var server = https.createServer(options, app);
server.listen(3001, () =>{
        console.log('HTTPS Server(3001) is running.');
});

