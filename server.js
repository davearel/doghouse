var app, port, settings;

if (process.env.NODE_ENV === 'development') {
  settings = require('./.app/lib/settings')
  settings.get()
}

app = require('./.app');

port = app.port;

app.listen(port, function() {
  return console.log("Listening on " + port + "\nPress CTRL-C to stop server.");
});
