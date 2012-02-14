vows   = require('vows')
sinon  = require('sinon')
assert = require('assert')
helper = require('../test_helper')
Pomodoro = helper.require(__filename).Pomodoro

class Client
  constructor: (id)->
    @id        = id
    @callbacks = {}
  on: (command,callback)=>
    @callbacks[command] = callback
  emit: (command,value)=>

WORKING = 1500
RESTING =  300
make = ->
  client = new Client()
  sinon.spy(client,'emit')
  
  pomodoro = new Pomodoro({working:WORKING,resting:RESTING})
  pomodoro.login(client)

  {pomodoro:pomodoro,client:client}

vows
  .describe('pomodoro')
  .addBatch
    'initialize':
      topic: ->
        client = new Client()
        new Pomodoro({working:WORKING,resting:RESTING}).login(client)

        client
      'commands': (topic)->
        assert.deepEqual(command for command,callback of topic.callbacks,['start','stop','pause','synchronize','ping','disconnect'])
    'login':
      topic: ->
        pomodoro = new Pomodoro({working:WORKING,resting:RESTING})
        pomodoro.login(new Client('1'))
        pomodoro.login(new Client('2'))

        pomodoro
      'multi users': (topic)->
        assert.deepEqual(id for id,user of topic.users,['1','2'])
    'start':
      topic: ->
        x = make()
        client = x.client
        client.callbacks['start'](WORKING)

        x
      'verify': (x)->
        assert.deepEqual(x.client.emit.getCall(0).args,['start',{state:'working',remain:WORKING,today:0,overall:0}])
        assert.equal(x.client.emit.callCount,1)
    'start -> stop':
      topic: ->
        x = make()
        client = x.client
        client.callbacks['start'](WORKING)
        client.callbacks['stop'](WORKING)

        x
      'verify': (x)->
        assert.deepEqual(x.client.emit.getCall(1).args,['stop' ,{state:'ready',remain:WORKING,today:0,overall:0}])
        assert.equal(x.client.emit.callCount,2)
    'turn':
      topic: ->
        @fake = sinon.useFakeTimers(0)

        x = make()
        client = x.client
        client.callbacks['start'](WORKING)

        @fake.tick(WORKING * 1000)
        x.pomodoro.beat()

        x
      'verify': (x)->
        assert.equal(x.client.emit.callCount,2)
        assert.deepEqual(x.client.emit.getCall(0).args,['start',{state:'working',remain:WORKING,today:0,overall:0}])
        assert.deepEqual(x.client.emit.getCall(1).args,['start',{state:'resting',remain:RESTING,today:1,overall:1}])
      teardown: ->
        @fake.restore()
  .export module
