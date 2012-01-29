class Binder
  constructor: (linkage,clock,controller) ->
    @linkage    = linkage
    @clock      = clock
    @controller = controller
  bind: (command) =>
    @controller[command] = =>
      @linkage.emit(command)
    @linkage.on(command,@clock[command])

class ClockController
  constructor: (linkage,clock) ->
    binder = new Binder(linkage,clock,this)
    binder.bind('start')
    binder.bind('stop')
    binder.bind('synchronize')

    this.ping = (callback)=>
      linkage.on('ping',callback)
      linkage.emit('ping')

    linkage.on('disconnect',=>
      clock.abort()
    )

module.exports.ClockController = ClockController
