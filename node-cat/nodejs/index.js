io = require('socket.io').listen(3001);
var Netcat = require('node-netcat');
var client = Netcat.client(23, '192.168.1.126');
var pin  = 5
var brightness = 0
var http = require("http");
client.start();

function handler(req, res){

  var form = '';

    form = '<!doctype html> \
	<html lang="en"> \
	<head> \
        <meta charset="UTF-8">  \
	<script src="https://cdn.socket.io/socket.io-1.4.4.js"></script> \
	<script> \
	var socket = io.connect(\'http://192.168.1.149:3001\'); \
	function updateOutput(no,val) { \
		socket.emit("slider", {pin: no, value: val}); \
	} \
	</script> \
	<style> \
	body { \
	  color: #404040; \
	  display: flex; \
	  flex-direction: column; \
	  justify-content: space-around; \
	  align-items: center; \
	  padding: 50px; \
	} \
	</style> \
    <title>NodeJS Slider</title> \
</head> \
<body> \
	<input type="range" min="0" max="1023" step="1" oninput="updateOutput(5,value)"> \
	<br> \
	<input type="range" min="0" max="1023" step="1" oninput="updateOutput(2,value)"> \
	<br> \
	<input type="range" min="0" max="1023" step="1" oninput="updateOutput(7,value)"> \
	<br> \
</body> \
</html>';

  res.setHeader('Content-Type', 'text/html');
  res.writeHead(200);
  res.end(form);
};
io.sockets.on('connection', function(socket) {

// receive changed value of slider send by client
socket.on('slider', function(data){
	brightness = data.value ;
	pin = data.pin;
	client.send('fade('+brightness+','+pin+')' + '\n', false);
//  client.send('pwm.setduty('+pin+','+brightness+')' + '\n', false);
	console.log("Pin "+ pin + ", Slider Value: " + brightness);    });
});

http.createServer(handler).listen(3000, function(err){
  if(err){
    console.log('Error starting http server');
  } else {
    console.log("Server running at http://localhost:3000/");
  };
});

client.on('open', function () {
  console.log('connect');
//  client.send('fade('+brightness+','+pin+')' + '\n', false);
//  client.send('print(pwm.getduty('+pin+'))'+ '\n');
});

client.on('data', function (data) {
  console.log(data.toString('ascii'));
//  client.send('fade('+brightness+','+pin+')' + '\n', false);
//  client.send('fade(100,5)' + '\n', true);
});

client.on('error', function (err) {
  console.log(err);
  this.start();
});

client.on('close', function () {
  console.log('close');
});