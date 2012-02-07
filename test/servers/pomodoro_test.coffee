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

make = ->
  client = new Client()
  sinon.spy(client,'emit')
  pomodoro = new Pomodoro({working:5,resting:5}).login(client)

  {pomodoro:pomodoro,client:client}

vows
  .describe('pomodoro')
  .addBatch
    'initialize':
      topic: ->
        client = new Client()
        new Pomodoro({working:5,resting:5}).login(client)

        client
      'commands': (topic)->
        assert.deepEqual(command for command,callback of topic.callbacks,['start','stop','synchronize','ping','disconnect'])
    'login':
      topic: ->
        pomodoro = new Pomodoro({working:5,resting:5})
        pomodoro.login(new Client('1'))
        pomodoro.login(new Client('2'))

        pomodoro
      'multi users': (topic)->
        assert.deepEqual(id for id,user of topic.users,['1','2'])
    'start':
      topic: ->
        x = make()
        client = x.client
        client.callbacks['start']()

        x
      'verify': (x)->
        assert.deepEqual(['start',{state:'working',remain:5}],x.client.emit.getCall(0).args)
        assert.equal(1,x.client.emit.callCount)
    'start -> stop':
      topic: ->
        x = make()
        client = x.client
        client.callbacks['start']()
        client.callbacks['stop']()

        x
      'verify': (x)->
        assert.deepEqual(['stop' ,{state:'ready'  ,remain:5}],x.client.emit.getCall(1).args)
        assert.equal(2,x.client.emit.callCount)
  .export module
