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
  start: =>
    this
  stop: =>
    new Ready(@time)
module.exports.Playing = Playing

class Ready
  constructor: (working)->
    @state   = 'ready'
    @command = 'stop'
    @working = working
  remain: =>
    @working
  start: =>
    new Playing('working',@working)
  stop: =>
    this
module.exports.Ready = Ready

