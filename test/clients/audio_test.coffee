vows   = require('vows')
sinon  = require('sinon')
assert = require('assert')
helper = require('../test_helper')
AudioWithLoop = helper.require(__filename).AudioWithLoop

class Audio
  addEventListener: =>

vows
  .describe('AudioWithLoop')
  .addBatch
    'constructor':
      topic: ->
        audio = new Audio()
        mock = sinon.mock(audio)
        spy = sinon.spy(audio, "addEventListener")

        new AudioWithLoop(audio,2)

        spy
      'set ended event': (spy) ->
        assert(spy.calledWith('ended'))

  .export module
