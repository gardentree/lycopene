getNow = ->
  Math.floor(new Date().getTime() / 1000)

class Playing
  constructor: (state,remain)->
    @state    = state
    @command  = 'start'
    @time     = remain
    @starting = getNow()
  remain: =>
    @time - (getNow() - @starting)
  start: (initial)=>
    this
  stop: (initial)=>
    new Ready('ready',initial)
  pause: (initial)=>
    new Ready('pausing',@remain())

module.exports.Playing = Playing

class Ready
  constructor: (state,working)->
    @state   = state
    @command = 'stop'
    @working = working
  remain: =>
    @working
  start: (initial)=>
    new Playing('working',@working)
  stop: (initial)=>
    this
  pause: (initial)=>
    this
module.exports.Ready = Ready

