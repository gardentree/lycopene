doctype 5
html ->
  head ->
    title "#{@title}"
    link rel:'stylesheet',href:'/stylesheets/style.css'
    script src:'/javascripts/jquery-1.7.1.min.js'
    coffeescript ->
      window.enter = ->
        window.location.href = "/rooms/#{$('#name').val()}"
  body ->
    div '#welcome',->
      form '#enter',onsubmit:"enter();return false;",->
        input '#name',type:'text',placeholder:'enter room name'
