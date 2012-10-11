doctype 5
html ->
  head ->
    title "lycopene - #{@title}"
    link rel:'stylesheet',href:'/stylesheets/lycopene.css'
    link rel:'stylesheet',href:'/stylesheets/pomodoro.css'
    link rel:'stylesheet',href:'http://fonts.googleapis.com/css?family=Inconsolata'
    script src:'/socket.io/socket.io.js'
    coffeescript ->
      this.lycopene = {}
      this.module = {exports: this.lycopene}
    script src:'/javascripts/jquery-1.7.1.min.js'
    script src:'/javascripts/clock.js'
    script src:'/javascripts/clock_controller.js'
    script src:'/javascripts/audio.js'
    script src:'/javascripts/pomodoro.js'
    script src:'/javascripts/analytics.js'
  body ->
    coffeescript ->
      $(document).ready( ->
        lycopene.host = window
        lycopene.io   = io

        window.controller = lycopene.build(lycopene,$)
        document.body.style.zoom=2
      )
      window.ring = (source)->
        controller.ring $(source)

    div '#clock',->
      div '#time',->
        span '#minute.number',-> '00'
        span '#second.number',-> '00'

      div '#display',->
        div '#controller',->
        div '#turn',->
          table '.turn',->
            tr ->
              td '.label',-> 'Pomodoros today'
              td '#today.count',-> '0'
            tr ->
              td '.label',-> 'Pomodoros overall'
              td '#overall.count',-> '0'

    div '#connecting',->
      div -> 'Now Connecting...'

    div style:"display: none;",->
      div '#ready',->
        button '#button1.button',onclick:'controller.prepare();controller.start();',-> 'Start'
      div '#working',->
        button '#button2left.button',onclick:'controller.pause();',-> 'Pause'
        button '#button2right.button',onclick:'controller.stop();',-> 'Stop'

      div '#resting',->
        button '#button1.button',onclick:'controller.stop();',-> 'Stop'
      div '#pausing',->
        button '#button1.button',onclick:'controller.start();',-> 'Start'

      div '#bell',->
        span '.yellow',onclick:'ring(this)','data-name':'coin'
        span '.red'   ,onclick:'ring(this)','data-name':'big'
        span '.green' ,onclick:'ring(this)','data-name':'jump'
        span '.blue'  ,onclick:'ring(this)','data-name':'in'
