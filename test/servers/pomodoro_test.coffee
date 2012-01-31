vows   = require('vows')
assert = require('assert')
helper = require('../test_helper')
Pomodoro = helper.require(__filename).Pomodoro

class Client
  constructor: (id)->
    @id = id
  on: =>

vows
  .describe('pomodoro')
  .addBatch
    'login':
      topic: ->
        pomodoro = new Pomodoro({working:5,resting:5})
        pomodoro.login(new Client('1'))
        pomodoro.login(new Client('2'))

        pomodoro
      'users': (topic)->
        assert.deepEqual(id for id,user of topic.users,['1','2'])
  .export module
