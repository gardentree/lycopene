should = require('should')
sinon  = require('sinon')
helper = require('../test_helper')
Pomodoro = helper.require(__filename).Pomodoro

WORKING = 1500
RESTING =  300
OVERALL = 3

class Client
  constructor: (id)->
    @id        = id
    @callbacks = {}
  on: (command,callback)=>
    @callbacks[command] = callback
  emit: (command,value)=>

make = ->
  client = new Client()
  sinon.spy(client,'emit')
  
  model = {overall:OVERALL,save:->}
  save = sinon.spy(model,'save')
  pomodoro = new Pomodoro(model,{working:WORKING,resting:RESTING})
  pomodoro.login(client)

  {pomodoro:pomodoro,client:client,save:save}

describe 'pomodoro',->
  describe 'initialize',->
    client = null
    before ->
      client = new Client()
      new Pomodoro({},{working:WORKING,resting:RESTING}).login(client)
    it 'commands',->
      (command for command,callback of client.callbacks).should.eql(['start','stop','pause','synchronize','ping','ring','disconnect'])
  describe 'login',->
    pomodoro = null
    before ->
      pomodoro = new Pomodoro({},{working:WORKING,resting:RESTING})
      pomodoro.login(new Client('1'))
      pomodoro.login(new Client('2'))
    it 'multi users',->
      (id for id,user of pomodoro.users).should.eql(['1','2'])
  describe 'start',->
    client = null
    before ->
      x = make()
      client = x.client
      client.callbacks['start'](WORKING)
    it 'verify',->
      (client.emit.getCall(0).args).should.eql(['start',{state:'working',remain:WORKING,today:0,overall:OVERALL}])
      client.emit.callCount.should.equal(1)
  describe 'start -> stop',->
    client = null
    before ->
      x = make()
      client = x.client
      client.callbacks['start'](WORKING)
      client.callbacks['stop'](WORKING)
    it 'verify',->
      (client.emit.getCall(1).args).should.eql(['stop',{state:'ready',remain:WORKING,today:0,overall:OVERALL}])
      client.emit.callCount.should.equal(2)
  describe 'turn',->
    client = null
    save   = null
    fake   = null
    before ->
      fake = sinon.useFakeTimers(0)

      x = make()
      client = x.client
      client.callbacks['start'](WORKING)

      fake.tick(WORKING * 1000)
      x.pomodoro.beat()

      save = x.save
    it 'verify',->
      client.emit.callCount.should.equal(2)
      client.emit.getCall(0).args.should.eql(['start',{state:'working',remain:WORKING,today:0,overall:OVERALL}])
      client.emit.getCall(1).args.should.eql(['start',{state:'resting',remain:RESTING,today:1,overall:OVERALL + 1}])
    it 'call save',->
      save.calledWith().should.be.true
    after ->
      fake.restore()
