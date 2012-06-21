doctype 5
html ->
  head ->
    title "list"
    link rel:'stylesheet',href:'/stylesheets/style.css'
    style '''
      #content {
        margin: 0 auto;
        width: 320px;
      }
      ul {
      }
      li {
        color: #fff;
        display: inline-block;
        list-style: none;
      }
      a {
        font-size:24pt
        background-color: #DFE8EF;
        border: 1px solid #9FB6C8;
        border-radius: 4px;
        margin: 8px;
        padding: 6px;
        display: block;
      }
    '''
    script src:'/javascripts/jquery-1.7.1.min.js'
  body ->
    div '#content',->
      ul ->
        for pomodoro in @pomodoros
          li -> a href:"/rooms/#{pomodoro.name}",-> pomodoro.name
