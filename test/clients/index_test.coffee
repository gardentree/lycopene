should = require('should')
assert = require('assert')
helper = require('../test_helper')
build = helper.require(__filename).build

createLinkage = ->
  class Linkage
    constructor:(name)->
      @name      = name
      @pair      = null
      @callbacks = {}
    on  :(command,callback)=>
      @callbacks[command] = callback
    emit:(command,value)=>
      unless @pair.callbacks[command]
        throw "#{@name}:#{command} is not defined"

      @pair.callbacks[command](value)

  client = new Linkage('client')
  server = new Linkage('server')
  client.pair = server
  server.pair = client

  {client:client,server:server}

class  Audio
  addEventListener:->
  play:->

OVERALL = 3
kick = (body,setup,callback)->
  jsdom    = require("jsdom").jsdom
  document = jsdom("<html><body>#{body}</body></html>")
  window   = document.createWindow()
  jsdom.jQueryify(window,->
    try
      pomodoro = new (helper.require("servers/pomodoro").Pomodoro)({overall:OVERALL},{working:5,resting:5})

      linkage = createLinkage()
      pomodoro.login(linkage.server)

      window.Audio = Audio
      lycopene =
        AudioWithLoop  :helper.require("clients/audio").AudioWithLoop
        host           :window
        Clock          :helper.require("clients/clock").Clock
        ClockController:helper.require("clients/clock_controller").ClockController
        io             :{connect:->linkage.client}

      controller = build(lycopene,window.jQuery)
      setup(controller) if setup?

      callback(window.jQuery)
    catch error
      callback(null,error)
  )

draft = """
  <div id="clock">
    <div id="time">
      <span id="minute"></span>
      <span id="second"></span>
    </div>
    <div id="controller"></div>
    <div id="turn">
      <div id="today"></div>
      <div id="overall"></div>
    </div>
  </div>
  <div id='connecting'></div>
  <div>
    <div id="ready">ready</div>
    <div id="working">working</div>
    <div id="resting">resting</div>
    <div id="pausing">pausing</div>
  </div>
"""

describe 'index',->
  describe 'initialize',->
    $ = null
    before (done)->
      kick(draft,null,(jQuery,error)->
        if error
          done(error)
          return

        $ = jQuery
        done()
      )
    it 'connecting is hidden',->
      $('#connecting').css('display').should.equal('none')
    it 'time is ready',->
      $('#time').attr('class').should.equal('ready')
    it 'controller is ready',->
      $('#controller').html().should.equal('ready')
  describe 'start',->
    $ = null
    before (done)->
      kick(draft,(controller)->
        controller.start()
      ,(jQuery,error)->
        if error
          done(error)
          return

        $ = jQuery
        done()
      )
    it 'time is working',->
      $('#time').attr('class').should.equal('working')
    it 'controller is ready',->
      $('#controller').html().should.equal('working')
    it 'today is 0',->
      $('#today').html().should.equal('0')
    it 'overall is not 0',->
      $('#overall').html().should.equal(new String(OVERALL))
  describe 'pause',->
    $ = null
    before (done)->
      kick(draft,(controller)->
        controller.start()
        controller.pause()
      ,(jQuery,error)->
        if error
          done(error)
          return

        $ = jQuery
        done()
      )
    it 'time is working',->
      $('#time').attr('class').should.equal('pausing')
    it 'controller is ready',->
      $('#controller').html().should.equal('pausing')
