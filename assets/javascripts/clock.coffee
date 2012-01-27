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
      state : 'ready'
      remain: -1
  start: (time)=>
    @time = time
    @timer = setInterval(@beat,1000) if !@timer?
  stop: (time)=>
    @stopTimer()

    @time = time
    @draw('ready')
  synchronize: (time)=>
    @time = time

    @draw(@time.state)
  abort: =>
    @stopTimer()
    @draw('abort')
  beat: =>
    @time.remain--

    @draw(@time.state)
  draw: (state)=>
    second = ('0' + (@time.remain % 60)).slice(-2)
    minute = ('0' + ((@time.remain - second) / 60)).slice(-2)

    @redraw(state,minute,second)
  stopTimer: =>
    clearInterval(@timer)
    @timer = null

window.build = (canvas) ->
  clock = new Clock(canvas)
  controller = new Object()

  linkage = io.connect('/')
  binder = new Binder(linkage,clock,controller)
  binder.bind('start')
  binder.bind('stop')
  binder.bind('synchronize')
  
  controller.ping = (callback)=>
    linkage.on('ping',callback)
    linkage.emit('ping')

  linkage.on('disconnect',=>
    clock.abort()
  )
  controller

