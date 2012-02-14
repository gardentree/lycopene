vows   = require('vows')
sinon  = require('sinon')
assert = require('assert')
helper = require('../test_helper')
Clock = helper.require(__filename).Clock

redraw = ->

vows
  .describe('Clock')
  .addBatch
    'constructor':
      topic: ->
        new Clock(->
        )
      'time': (topic) ->
        assert.deepEqual {state:'ready',remain:-1},topic.time
    'start':
      topic: ->
        redraw = sinon.spy()
        @fake = sinon.useFakeTimers(0)
        new Clock(redraw).start({state:'working',remain:1000})
        redraw
      'first time': (redraw) ->
        assert.equal     redraw.callCount      ,1
        assert.deepEqual redraw.getCall(0).args,['working','16','40']
      'next time':
        topic:(redraw)->
          @fake.tick(1000)
          redraw
        'redraw': (redraw) ->
          assert.equal     redraw.callCount      ,2
          assert.deepEqual redraw.getCall(1).args,['working','16','39']
      teardown: ->
        @fake.restore()
    'stop':
      topic: ->
        redraw = sinon.spy()
        @fake = sinon.useFakeTimers(0)
        new Clock(redraw).stop({state:'working',remain:1000})
        redraw
      'first time': (redraw) ->
        assert.equal     redraw.callCount      ,1
        assert.deepEqual redraw.getCall(0).args,['working','16','40']
      'next time':
        topic:(redraw)->
          @fake.tick(1000)
          redraw
        'redraw': (redraw) ->
          assert.equal redraw.callCount,1
      teardown: ->
        @fake.restore()
    'pause':
      topic: ->
        redraw = sinon.spy()
        @fake = sinon.useFakeTimers(0)
        new Clock(redraw).pause({state:'working',remain:1000})
        redraw
      'first time': (redraw) ->
        assert.equal     redraw.callCount      ,1
        assert.deepEqual redraw.getCall(0).args,['working','16','40']
      'next time':
        topic:(redraw)->
          @fake.tick(1000)
          redraw
        'redraw': (redraw) ->
          assert.equal redraw.callCount,1
      teardown: ->
        @fake.restore()
    'synchronize':
      topic: ->
        redraw = sinon.spy()
        @fake = sinon.useFakeTimers(0)
        new Clock(redraw).synchronize({state:'working',remain:1000})
        redraw
      'first time': (redraw) ->
        assert.equal     redraw.callCount      ,1
        assert.deepEqual redraw.getCall(0).args,['working','16','40']
      'next time':
        topic:(redraw)->
          @fake.tick(1000)
          redraw
        'redraw': (redraw) ->
          assert.equal redraw.callCount,1
      teardown: ->
        @fake.restore()

  .export module
