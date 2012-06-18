should = require('should')
sinon  = require('sinon')
helper = require('../test_helper')
AudioWithLoop = helper.require(__filename).AudioWithLoop

class Audio
  addEventListener: =>

describe 'AudioWithLoop',->
  spy = null
  before ->
    audio = new Audio()
    spy = sinon.spy(audio, "addEventListener")

    new AudioWithLoop(audio,2)
  it 'set ended event',->
    spy.calledWith('ended').should.be.true
