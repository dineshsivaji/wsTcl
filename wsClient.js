var connection = new WebSocket('ws://135.249.31.148:1617/sample');
// When the connection is open, send some data to the server
connection.onopen = function () {
  connection.send('hai'); // Send the message 'Ping' to the server
};

// Log errors
connection.onerror = function (error) {
  console.log('WebSocket Error ' + error);
};

// Log messages from the server
connection.onmessage = function (e) {
  console.log('Server: ' + e.data);
};

connection.onclose = function (e) {
	console.log('Onclose called' + event);
    console.log('code is' + event.code);
    console.log('reason is ' + event.reason);
}
