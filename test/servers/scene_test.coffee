should = require('should')
sinon  = require('sinon')
helper = require('../test_helper')

scene = helper.require(__filename)
Playing = scene.Playing
Ready   = scene.Ready

STATUS = 'working'
TIME   = 5

describe 'scene',->
  describe 'playing',->
    clock   = null
    playing = null
    before ->
      clock = sinon.useFakeTimers()
      playing = new Playing(STATUS,TIME)
    it 'initial',->
      playing.state.should.equal(STATUS)
      playing.command.should.equal('start')
      playing.remain().should.equal(TIME)
    describe 'command',->
      before ->
        clock.tick(1000)
      it 'start',->
        scene = playing.start(TIME)
        scene.state.should.equal('working')
        scene.command.should.equal('start')
        scene.remain().should.equal(TIME - 1)
      it 'stop',->
        scene = playing.stop(TIME)
        scene.state.should.equal('ready')
        scene.command.should.equal('stop')
        scene.remain().should.equal(TIME)
      it 'pause',->
        scene = playing.pause(TIME)
        scene.state.should.equal('pausing')
        scene.command.should.equal('stop')
        scene.remain().should.equal(TIME - 1)
    after ->
      clock.restore()
  describe 'ready',->
    clock = null
    ready = null
    before ->
      clock = sinon.useFakeTimers()
      ready = new Ready('ready',TIME)
    it 'initial',->
      ready.state.should.equal('ready')
      ready.command.should.equal('stop')
      ready.remain().should.equal(TIME)
    describe 'command',->
      before ->
        clock.tick(1000)
      it 'start',->
        scene = ready.start(TIME)
        scene.state.should.equal('working')
        scene.command.should.equal('start')
        scene.remain().should.equal(TIME)
      it 'stop',->
        scene = ready.stop(TIME)
        scene.state.should.equal('ready')
        scene.command.should.equal('stop')
        scene.remain().should.equal(TIME)
      it 'pause',->
        scene = ready.pause(TIME)
        scene.state.should.equal('ready')
        scene.command.should.equal('stop')
        scene.remain().should.equal(TIME)
    after ->
      clock.restore()
  describe 'start > pause > start > stop',->
    clock = null
    scene = null
    before ->
      clock = sinon.useFakeTimers()

      scene = new Playing(STATUS,TIME)
      clock.tick(1000)
      scene.pause(TIME)
      scene.start(TIME)
      scene = scene.stop(TIME)
    it 'command',->
      scene.state.should.equal('ready')
      scene.command.should.equal('stop')
      scene.remain().should.equal(TIME)
    after ->
      clock.restore()
