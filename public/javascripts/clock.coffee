class Binder
  constructor: (linkage,clock,controller) ->
    @linkage    = linkage
    @clock      = clock
    @controller = controller
  bind: (command) =>
    @controller[command] = =>
      @linkage.emit(command)
    @linkage.on(command,@clock[command])

class Clock
  constructor: (redraw) ->
    @redraw  = redraw
    @time =
      state : 'pausing'
      remain: -1
  start: (time)=>
    @time = time
    @timer = setInterval(@beat,1000) if !@timer?
  pause: (time)=>
    clearInterval(@timer)
    @timer = null

    @time = time
    @draw('pausing')
  synchronize: (time)=>
    @time = time

    @draw(@time.state)
  beat: =>
    @time.remain--

    @draw(@time.state)
  draw: (state)=>
    second = ('0' + (@time.remain % 60)).slice(-2)
    minute = ('0' + ((@time.remain - second) / 60)).slice(-2)

    @redraw(state,minute,second)

window.build = (canvas) ->
  clock = new Clock(canvas)
  controller = new Object()

  binder = new Binder(io.connect('/'),clock,controller)
  binder.bind('start')
  binder.bind('pause')
  binder.bind('synchronize')
  
  controller.synchronize()

  controller

