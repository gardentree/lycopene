vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
build = helper.require(__filename).build

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
          lycopene =
            AudioWithLoop  :helper.require("clients/audio").AudioWithLoop
            Audio          :->{addEventListener:->}
            Clock          :helper.require("clients/clock").Clock
            ClockController:helper.require("clients/clock_controller").ClockController
            io             :{connect:->{
              on:->
              emit:->
            }}
          try
            controller = build(lycopene,window.jQuery)
            promise.emit('success',window.jQuery)
          catch error
            promise.emit('error',error)
        )

        promise
      'controller': ($)->
        assert.equal($('#connecting').attr('style'),'')
  .export module
