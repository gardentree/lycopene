doctype 5
html ->
  head ->
    title "list"
    link rel:'stylesheet',href:'/stylesheets/lycopene.css'
    link rel:'stylesheet',href:'/stylesheets/list.css'
    script src:'/javascripts/jquery-1.7.1.min.js'
  body ->
    div '#content',->
      ul ->
        for pomodoro in @pomodoros
          li -> a href:"/rooms/#{pomodoro.name}",-> pomodoro.name
