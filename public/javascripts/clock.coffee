class Binder
  constructor: (linkage,clock,controller) ->
    @linkage    = linkage
    @clock      = clock
    @controller = controller
  bind: (name) =>
    @controller[name] = =>
      @linkage.emit('notify',{command: name})
    @linkage.on(name,@clock[name])

WORKING_TIME = 1500
BREAK_TIME   = 300
class Clock
  constructor: (canvas) ->
    @canvas  = canvas
    @time    = WORKING_TIME
    @working = true
    @draw()

  start: =>
    @timer = setInterval(@beat,1000)

  stop: =>
    clearInterval(@timer)

  beat: =>
    @time--
    if @time <= 0
      @working = !@working
      if @working
        @time = WORKING_TIME
      else
        @time = BREAK_TIME

    @draw()

  draw: =>
    second = ('0' + (@time % 60)).slice(-2)
    minute = ('0' + ((@time - second) / 60)).slice(-2)

    @canvas.empty()
    @canvas.append("<span>#{minute}</span><span>:</span><span>#{second}</span>")

window.build = (canvas) ->
  clock = new Clock(canvas)
  controller = new Object()

  binder = new Binder(io.connect('/'),clock,controller)
  binder.bind('start')
  binder.bind('stop')

  controller
