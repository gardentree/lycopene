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

port = process.env.PORT || 3000
app.listen(port, ->
  console.log("Listening on " + port)
)

#---------
config = require("./config/environments/#{process.env.NODE_ENV||'development'}")

#---------
socket = io.listen(app)

# Routes
rooms = {}
app.get('/',(request, response) ->
  response.render('welcome',{title:'lycopene'})
)
app.get('/rooms/:name',(request, response) ->
  name = request.params.name
  unless rooms[name]
    pomodoro = new (require('./assets/servers/pomodoro').Pomodoro)(config)

    socket.of(request.originalUrl).on('connection',pomodoro.login)

    rooms[name] = pomodoro

  response.render('room',{title:name})
)

setInterval(->
  pomodoro.beat() for name,pomodoro of rooms
,1000)
