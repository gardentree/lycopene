getNow = ->
  Math.floor(new Date().getTime() / 1000)
isEmpty = (object)->
  return false for key,value of object
  return true

scene = require('./scene')
class Pomodoro
  constructor: (model,config)->
    @model  = model
    @users  = {}
    @status = new scene.Ready('ready',config.working)
    @config = config
    @today  = 0
    @timer  = null
  broadcast: (command,data)=>
    user.emit(command,data) for id,user of @users
  scene: =>
    state  :@status.state
    remain :@status.remain()
    today  :@today
    overall:@model.overall
  login: (client)=>
    @users[client.id] = client

    for command in ['start','stop','pause']
      do (command)=>
        client.on(command,(data) =>
          @status = @status[command](@config.working)
          @broadcast(command,@scene())
        )
    client.on('synchronize', =>
      client.emit(@status.command,@scene())
    )
    client.on('ping',=>
      client.emit('ping')
    )
    client.on('ring',(bell)=>
      @broadcast('ring',bell)
    )
    client.on('disconnect', =>
      console.log("disconnect #{client}")
      delete @users[client.id]

      if isEmpty(@users)
        clearInterval(@timer)
        @timer = null
        console.log "stop beat of " + @model.name
    )

    @timer = setInterval(@beat,1000) unless @timer
  beat: =>
    remain = @status.remain()
    if remain <= 0
      switch @status.state
        when 'working'
          @status = new scene.Playing('resting',@config.resting)
          @today++

          @model.overall++
          @model.save((error) ->
            console.log error if error
          )
        when 'resting'
          @status = new scene.Playing('working',@config.working)
      @broadcast('start',@scene())
    else if remain % 60 == 30
      @broadcast(@status.command,@scene())

module.exports.Pomodoro = Pomodoro
