getNow = ->
  Math.floor(new Date().getTime() / 1000)

scene = require('./scene')
class Pomodoro
  constructor: (config)->
    @users  = {}
    @status = new scene.Ready('ready',config.working)
    @config = config
  broadcast: (command,data)=>
    user.emit(command,data) for id,user of @users
  login: (client)=>
    @users[client.id] = client

    for command in ['start','stop','pause']
      do (command)=>
        client.on(command,(data) =>
          @status = @status[command](@config.working)
          @broadcast(command,{state: @status.state,remain: @status.remain()})
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
          @status = new scene.Playing('resting',@config.resting)
        when 'resting'
          @status = new scene.Playing('working',@config.working)
      @broadcast('start',{state: @status.state,remain: @status.remain()})

module.exports.Pomodoro = Pomodoro
