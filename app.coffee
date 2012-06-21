# Module dependencies.
express = require('express')
routes = require('./routes')
io = require('socket.io')

app = module.exports = express.createServer()

# Configuration
app.configure( ->
  app.set('views', __dirname + '/views')
  app.set('view options', {layout: false})
  app.set("view engine", "coffee")
  app.use(express.bodyParser())
  app.use(express.methodOverride())
  app.use(require('stylus').middleware({ src: __dirname + '/public' }))
  app.use(express.cookieParser())
  app.use(express.session({ secret: 'your secret here' }))
  app.use(app.router)
  app.use(express.static(__dirname + '/public'))

  app.register '.coffee', require('coffeekup').adapters.express
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

#---------
mongoose = require('mongoose')
do ->
  Schema = mongoose.Schema

  mongoose.connect(process.env.MONGOHQ_URL||'mongodb://localhost/lycopene')
  mongoose.model('Pomodoro',new Schema({
    name:    String
    overall: Number
  }))
Pomodoro = mongoose.model('Pomodoro')

# Routes
pomodoros = {}
app.get('/',(request, response) ->
  response.render('welcome',{title:'lycopene'})
)

app.get '/pomodoros/',(request, response) ->
  Pomodoro.find {},(error,records) ->
    response.render('list',{pomodoros:records})

app.get('/pomodoros/:name',(request, response) ->
  name = request.params.name

  unless pomodoros[name]
    Pomodoro.find({name: request.params.name},(error,records) ->
      if error
        console.log error
        return
      
      model = null
      if records.length > 0
        model = records[0]
      else
        model = new Pomodoro({
          name:    request.params.name
          overall: 0
        })
        model.save((error) ->
          console.log error if error
        )
      console.log model

      pomodoro = new (require('./assets/servers/pomodoro').Pomodoro)(model,config)
      socket.of(request.originalUrl).on('connection',pomodoro.login)
      pomodoros[name] = pomodoro
      
    )
  response.render('pomodoro',{title:name})
)
