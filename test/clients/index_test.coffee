vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
build = helper.require(__filename).build

createLinkage = ->
  class Linkage
    constructor:(name)->
      @name      = name
      @pair      = null
      @callbacks = {}
    on  :(command,callback)=>
      @callbacks[command] = callback
    emit:(command,value)=>
      unless @pair.callbacks[command]
        throw "#{@name}:#{command} is not defined"

      @pair.callbacks[command](value)

  client = new Linkage('client')
  server = new Linkage('server')
  client.pair = server
  server.pair = client

  {client:client,server:server}

class  Audio
  addEventListener:->
  play:->

kick = (body,setup)->
  promise = new (require('events').EventEmitter)()

  jsdom    = require("jsdom").jsdom
  document = jsdom("<html><body>#{body}</body></html>")
  window   = document.createWindow()
  jsdom.jQueryify(window,->
    pomodoro = new (helper.require("servers/pomodoro").Pomodoro)({working:5,resting:5})

    linkage = createLinkage()
    pomodoro.login(linkage.server)

    window.Audio = Audio
    lycopene =
      AudioWithLoop  :helper.require("clients/audio").AudioWithLoop
      host           :window
      Clock          :helper.require("clients/clock").Clock
      ClockController:helper.require("clients/clock_controller").ClockController
      io             :{connect:->linkage.client}
    try
      controller = build(lycopene,window.jQuery)
      setup(controller) if setup?
      promise.emit('success',window.jQuery)
    catch error
      promise.emit('error',error)
  )

  promise

draft = """
  <div id="clock">
    <div id="time">
      <span id="minute"></span>
      <span id="second"></span>
    </div>
    <div id="controller"></div>
    <div id="turn">
      <div id="today"></div>
      <div id="overall"></div>
    </div>
  </div>
  <div id='connecting'></div>
  <div>
    <div id="ready">ready</div>
    <div id="working">working</div>
    <div id="resting">resting</div>
    <div id="pausing">pausing</div>
  </div>
"""

vows
  .describe('index')
  .addBatch
    'initialize':
      topic: ->
        kick(draft)
      'connecting is hidden': ($)->
        assert.equal($('#connecting').css('display'),'none')
      'time is ready': ($)->
        assert.equal($('#time').attr('class'),'ready')
      'controller is ready': ($)->
        assert.equal($('#controller').html(),'ready')
    'start':
      topic: ->
        kick(draft,(controller)->
          controller.start()
        )
      'time is working': ($)->
        assert.equal($('#time').attr('class'),'working')
      'controller is ready': ($)->
        assert.equal($('#controller').html(),'working')
      'today is 0': ($)->
        assert.equal($('#today').html(),'0')
      'overall is 0': ($)->
        assert.equal($('#overall').html(),'0')
    'pause':
      topic: ->
        kick(draft,(controller)->
          controller.start()
          controller.pause()
        )
      'time is working': ($)->
        assert.equal($('#time').attr('class'),'pausing')
      'controller is ready': ($)->
        assert.equal($('#controller').html(),'pausing')
  .export module
