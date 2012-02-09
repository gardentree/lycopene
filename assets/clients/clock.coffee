class Clock
  constructor: (redraw) ->
    @redraw  = redraw
    @time =
      state : 'ready'
      remain: -1
  start: (time)=>
    @time = time

    @draw(@time.state)
    @timer = setInterval(@beat,1000) if !@timer?
  stop: (time)=>
    @stopTimer()

    @time = time
    @draw(@time.state)
  pause: (time)=>
    @stop(time)
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
module.exports.Clock = Clock
