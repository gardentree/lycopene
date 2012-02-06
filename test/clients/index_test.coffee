vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
build = helper.require(__filename).build

createLinkage = ->
  class Linkage
    constructor:()->
      @pair      = null
      @callbacks = {}
    on  :(command,callback)=>
      @callbacks[command] = callback
    emit:(command,value)=>
      @pair.callbacks[command](value)

  client = new Linkage()
  server = new Linkage()
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

    lycopene =
      AudioWithLoop  :helper.require("clients/audio").AudioWithLoop
      Audio          :Audio
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
  </div>
  <div id='connecting'></div>
  <div>
    <div id="ready">ready</div>
    <div id="working">working</div>
    <div id="resting">resting</div>
  </div>
"""

vows
  .describe('index')
  .addBatch
    'initialize':
      topic: -> kick(draft)
      'connecting is hidden': ($)-> assert.equal($('#connecting').css('display'),'none')
      'time is ready'       : ($)-> assert.equal($('#time').attr('class')       ,'ready')
  .export module
