should = require('should')
helper = require('../test_helper')
ClockController = helper.require(__filename).ClockController

class Socket
  on: =>
  emit: =>

describe 'ClockController',->
  describe 'constructor',->
    it 'command',->
      controller = new ClockController(new Socket(),{})

      controller.start.should.be.a('function')
      controller.stop.should.be.a('function')
      controller.pause.should.be.a('function')
      controller.synchronize.should.be.a('function')
