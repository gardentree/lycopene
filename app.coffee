
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
getNow = ->
  Math.floor(new Date().getTime() / 1000)

class Playing
  constructor: (state,remain)->
    @state    = state
    @command = 'start'
    @time    = remain
    @starting   = getNow()
  remain: =>
    @time - (getNow() - @starting)
  start: =>
    this
  pause: =>
    new Pausing(@state,@remain())

class Pausing
  constructor: (state,remain)->
    @state        = state
    @command     = 'pause'
    @remain_time = remain
  remain: =>
    @remain_time
  start: =>
    new Playing(@state,@remain_time)
  pause: =>
    this

#---------
users = {}

status = new Pausing('working',config.working)

emit = (command,data)->
  user.emit(command,data) for id,user of users

socket = io.listen(app)
socket.sockets.on('connection',(client) ->
  users[client.id] = client

  client.on('start',(data) =>
    status = status.start()
    emit('start',{state: status.state,remain: status.remain()})
  )
  client.on('pause',(data) =>
    status = status.pause()
    emit('pause',{state: status.state,remain: status.remain()})
  )
  client.on('synchronize',(data) =>
    client.emit(status.command,{state: status.state,remain: status.remain()})
  )
  client.on('ping',=>
    client.emit('ping')
  )
  client.on('disconnect', =>
    console.log("disconnect #{client}")
    delete users[client.id]
  )

  setInterval(->
    if status.remain() <= 0
      switch status.state
        when 'working'
          status = new Playing('resting',config.resting)
        when 'resting'
          status = new Playing('working',config.working)
      emit('start',{state: status.state,remain: status.remain()})
  ,1000)
)
