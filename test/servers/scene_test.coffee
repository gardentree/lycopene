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
          topic: (topic)-> topic.start()
          'attribute': (topic)->
            assert.equal(topic.state   ,'working')
            assert.equal(topic.command ,'start')
            assert.equal(topic.remain(),TIME - 1)
        'stop':
          topic: (topic)-> topic.stop()
          'attribute': (topic)->
            assert.equal(topic.state   ,'ready')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME)
      teardown:->
        @clock.restore()
  .addBatch
    'ready':
      topic: ->
        @clock = sinon.useFakeTimers()
        new Ready(TIME)
      'attribute': (topic)->
        assert.equal(topic.state   ,'ready')
        assert.equal(topic.command ,'stop')
        assert.equal(topic.remain(),TIME)
      'command':
        topic: (topic)->
          @clock.tick(1000)
          topic
        'start':
          topic: (topic)-> topic.start()
          'attribute': (topic)->
            assert.equal(topic.state   ,'working')
            assert.equal(topic.command ,'start')
            assert.equal(topic.remain(),TIME)
        'stop':
          topic: (topic)-> topic.stop()
          'attribute': (topic)->
            assert.equal(topic.state   ,'ready')
            assert.equal(topic.command ,'stop')
            assert.equal(topic.remain(),TIME)
      teardown:->
        @clock.restore()

 .export module
