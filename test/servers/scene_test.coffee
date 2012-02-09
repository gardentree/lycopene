vows   = require('vows')
sinon  = require('sinon')
assert = require('assert')
helper = require('../test_helper')

scene = helper.require(__filename)
Playing = scene.Playing
Ready   = scene.Ready

STATUS = 'working'
TIME   = 5

vows
  .describe('scene')
  .addBatch
    'playing':
      topic: ->
        @clock = sinon.useFakeTimers()
        new Playing(STATUS,TIME)
      'attribute': (topic)->
        assert.equal(topic.state   ,STATUS)
        assert.equal(topic.command ,'start')
        assert.equal(topic.remain(),TIME)
      'command':
        topic: (topic)->
          @clock.tick(1000)
          topic
        'start':
          topic: (topic)-> topic.start(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'working')
            assert.equal(topic.command ,'start')
            assert.equal(topic.remain(),TIME - 1)
        'stop':
          topic: (topic)-> topic.stop(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'ready')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME)
        'pause':
          topic: (topic)-> topic.pause(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'pausing')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME - 1)
      teardown:->
        @clock.restore()
  .addBatch
    'ready':
      topic: ->
        @clock = sinon.useFakeTimers()
        new Ready('ready',TIME)
      'attribute': (topic)->
        assert.equal(topic.state   ,'ready')
        assert.equal(topic.command ,'stop')
        assert.equal(topic.remain(),TIME)
      'command':
        topic: (topic)->
          @clock.tick(1000)
          topic
        'start':
          topic: (topic)-> topic.start(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'working')
            assert.equal(topic.command ,'start')
            assert.equal(topic.remain(),TIME)
        'stop':
          topic: (topic)-> topic.stop(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'ready')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME)
        'pause':
          topic: (topic)-> topic.pause(TIME)
          'attribute': (topic)->
            assert.equal(topic.state   ,'ready')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME)
      teardown:->
        @clock.restore()
  .addBatch
    'start > pause > start > stop':
      topic: ->
        @clock = sinon.useFakeTimers()

        topic = new Playing(STATUS,TIME)
        @clock.tick(1000)
        topic.pause(TIME)
        topic.start(TIME)
        topic.stop(TIME)
      'command':(topic)->
        assert.equal(topic.state   ,'ready')
        assert.equal(topic.command ,'stop')
        assert.equal(topic.remain(),TIME)
      teardown:->
        @clock.restore()

 .export module
