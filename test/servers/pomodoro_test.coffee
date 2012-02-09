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
  pomodoro = new Pomodoro({working:WORKING,resting:RESTING}).login(client)

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
        assert.deepEqual(['start',{state:'working',remain:WORKING}],x.client.emit.getCall(0).args)
        assert.equal(1,x.client.emit.callCount)
    'start -> stop':
      topic: ->
        x = make()
        client = x.client
        client.callbacks['start'](WORKING)
        client.callbacks['stop'](WORKING)

        x
      'verify': (x)->
        assert.deepEqual(['stop' ,{state:'ready'  ,remain:WORKING}],x.client.emit.getCall(1).args)
        assert.equal(2,x.client.emit.callCount)
  .export module
