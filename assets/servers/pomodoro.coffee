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

# class Pausing
#   constructor: (state,remain)->
#     @state        = state
#     @command     = 'stop'
#     @remain_time = remain
#   remain: =>
#     @remain_time
#   start: =>
#     new Playing(@state,@remain_time)
#   stop: =>
#     this

class Pomodoro
  constructor: (config)->
    @users  = {}
    @status = new Ready(config.working)
    @config = config
  broadcast: (command,data)=>
    user.emit(command,data) for id,user of @users
  login: (client)=>
    @users[client.id] = client

    client.on('start',(data) =>
      @status = @status.start()
      @broadcast('start',{state: @status.state,remain: @status.remain()})
    )
    client.on('stop',(data) =>
      @status = @status.stop()
      @broadcast('stop',{state: @status.state,remain: @status.remain()})
    )
    client.on('synchronize', =>
      client.emit(@status.command,{state: @status.state,remain: @status.remain()})
    )
    client.on('ping',=>
      client.emit('ping')
    )
    client.on('disconnect', =>
      console.log("disconnect #{client}")
      delete @users[client.id]
    )
  beat: =>
    if @status.remain() <= 0
      switch @status.state
        when 'working'
          @status = new Playing('resting',@config.resting)
        when 'resting'
          @status = new Playing('working',@config.working)
      @broadcast('start',{state: @status.state,remain: @status.remain()})

module.exports.Pomodoro = Pomodoro
