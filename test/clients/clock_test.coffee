should = require('should')
sinon  = require('sinon')
helper = require('../test_helper')
Clock = helper.require(__filename).Clock

redraw = ->

describe 'Clock',->
  describe 'constructor',->
    it 'time',->
      new Clock(->).time.should.eql({state:'ready',remain:-1})
  describe 'start',->
    redraw = null
    fake   = null
    before ->
      redraw = sinon.spy()
      fake = sinon.useFakeTimers(0)
      new Clock(redraw).start({state:'working',remain:1000})

    it 'first time',->
      redraw.callCount.should.equal(1)
      redraw.getCall(0).args[0].should.eql({state:'working',remain:1000})
    it 'next time',->
      before ->
        fake.tick(1000)
      it 'redraw', ->
        redraw.callCount.should.equal(2)
        redraw.getCall(1).args[0].should.eql({state:'working',remain:999})
    after ->
      fake.restore()
  describe 'stop',->
    redraw = null
    fake   = null
    before ->
      redraw = sinon.spy()
      fake = sinon.useFakeTimers(0)
      new Clock(redraw).stop({state:'working',remain:1000})

    it 'first time',->
      redraw.callCount.should.equal(1)
      redraw.getCall(0).args[0].should.eql(state:'working',remain:1000)
    it 'next time',->
      before ->
        fake.tick(1000)
        redraw
      it 'redraw',->
        redraw.callCount.should.equal(1)
    after ->
      fake.restore()
  describe 'pause',->
    redraw = null
    fake   = null
    before ->
      redraw = sinon.spy()
      fake = sinon.useFakeTimers(0)
      new Clock(redraw).pause({state:'working',remain:1000})

    it 'first time',->
      redraw.callCount.should.equal(1)
      redraw.getCall(0).args[0].should.eql({state:'working',remain:1000})
    it 'next time',->
      before ->
        fake.tick(1000)
        redraw
      it 'redraw',->
        redraw.callCount.should.equal(1)
    after ->
      fake.restore()
  describe 'synchronize',->
    redraw = null
    fake   = null
    before ->
      redraw = sinon.spy()
      fake = sinon.useFakeTimers(0)
      new Clock(redraw).synchronize({state:'working',remain:1000})

    it 'first time',->
      redraw.callCount.should.equal(1)
      redraw.getCall(0).args[0].should.eql({state:'working',remain:1000})
    it 'next time',->
      before ->
        fake.tick(1000)
        redraw
      it 'redraw',->
        redraw.callCount.should.equal(1)
    after ->
      fake.restore()
  describe 'abort',->
    redraw = null
    fake   = null
    before ->
      redraw = sinon.spy()
      fake = sinon.useFakeTimers(0)
      clock = new Clock(redraw)
      clock.start({state:'working',remain:1000})
      clock.abort()
      fake.tick(1000)

    it 'first time',->
      redraw.callCount.should.equal(2)
      redraw.getCall(1).args[0].should.eql({state:'abort',remain:1000})
