vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
Clock = helper.require(__filename).Clock

vows
  .describe('Clock')
  .addBatch
    'constructor':
      topic: ->
        new Clock(->
        )
      'time': (topic) ->
        assert.deepEqual topic.time, {state: 'ready',remain: -1}

  .export module
