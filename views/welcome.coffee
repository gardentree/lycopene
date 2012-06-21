doctype 5
html ->
  head ->
    title "#{@title}"
    link rel:'stylesheet',href:'/stylesheets/lycopene.css'
    link rel:'stylesheet',href:'/stylesheets/welcome.css'
    script src:'/javascripts/jquery-1.7.1.min.js'
    coffeescript ->
      window.enter = ->
        window.location.href = "/pomodoros/#{$('#name').val()}"
  body ->
    div '#welcome',->
      form '#enter',onsubmit:"enter();return false;",->
        input '#name',type:'text',placeholder:'enter task name'
