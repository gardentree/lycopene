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

vows
  .describe('index')
  .addBatch
    'build':
      topic: ->
        promise = new (require('events').EventEmitter)()

        jsdom    = require("jsdom").jsdom
        document = jsdom("<html><body><div id='connecting'></div></body></html>")
        window   = document.createWindow()
        jsdom.jQueryify(window,->
          pomodoro = new (helper.require("servers/pomodoro").Pomodoro)({working:5,resting:5})

          linkage = createLinkage()
          pomodoro.login(linkage.server)

          lycopene =
            AudioWithLoop  :helper.require("clients/audio").AudioWithLoop
            Audio          :->{addEventListener:->}
            Clock          :helper.require("clients/clock").Clock
            ClockController:helper.require("clients/clock_controller").ClockController
            io             :{connect:->linkage.client}
          try
            controller = build(lycopene,window.jQuery)
            promise.emit('success',window.jQuery)
          catch error
            promise.emit('error',error)
        )

        promise
      'controller': ($)->
        assert.equal($('#connecting').css('display'),'none')
  .export module
