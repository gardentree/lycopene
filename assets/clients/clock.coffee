class Clock
  constructor: (redraw) ->
    @redraw  = redraw
    @time =
      state : 'ready'
      remain: -1
  start: (time)=>
    @time = time

    @draw()
    @timer = setInterval(@beat,1000) if !@timer?
  stop: (time)=>
    @stopTimer()

    @time = time
    @draw()
  pause: (time)=>
    @stop(time)
  synchronize: (time)=>
    @time = time

    @draw()
  abort: =>
    @stopTimer()

    @time.state = 'abort'
    @draw()
  beat: =>
    @time.remain--

    @draw()
  draw: =>
    @redraw(@time)
  stopTimer: =>
    clearInterval(@timer)
    @timer = null
module.exports.Clock = Clock
