doctype 5
html ->
  head ->
    title "list"
    link rel:'stylesheet',href:'/stylesheets/lycopene.css'
    link rel:'stylesheet',href:'/stylesheets/list.css'
    script src:'/javascripts/jquery-1.7.1.min.js'
    script src:'/javascripts/mouseflow.js'
    script src:'/javascripts/analytics.js'
  body ->
    div '#content',->
      ul ->
        for pomodoro in @pomodoros
          li -> a href:"/pomodoros/#{pomodoro.name}",-> pomodoro.name
