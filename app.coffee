
# Module dependencies.

express = require('express')
routes = require('./routes')
io = require('socket.io')

app = module.exports = express.createServer()

# Configuration

app.configure( ->
  app.set('views', __dirname + '/views')
  app.set('view engine', 'jade')
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(require('stylus').middleware({ src: __dirname + '/public' }))
  app.use(express.cookieParser())
  app.use(express.session({ secret: 'your secret here' }))
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))
)

app.configure('development', ->
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))
)

app.configure('production', ->
  app.use(express.errorHandler())
)

# Routes

app.get('/', routes.index)

port = process.env.PORT || 3000
app.listen(port, ->
  console.log("Listening on " + port)
)

#---------
config = require("./config/environments/#{process.env.NODE_ENV||'development'}")

#---------
pomodoro = new (require('./assets/servers/pomodoro').Pomodoro)(config)

socket = io.listen(app)
socket.sockets.on('connection',pomodoro.login)

setInterval(pomodoro.beat,1000)
