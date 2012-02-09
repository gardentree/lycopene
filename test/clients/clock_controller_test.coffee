vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
ClockController = helper.require(__filename).ClockController

class Socket
  on: =>
  emit: =>

vows
  .describe('ClockController')
  .addBatch
    'constructor':
      topic: ->
        new ClockController(new Socket(),{})
      'command': (topic) ->
        assert.isFunction(topic.start)
        assert.isFunction(topic.stop)
        assert.isFunction(topic.pause)
        assert.isFunction(topic.synchronize)

  .export module
