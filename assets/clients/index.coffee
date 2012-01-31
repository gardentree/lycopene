module.exports.build = (lycopene,$)->
  controller = do ->
    notify  = new lycopene.AudioWithLoop(new lycopene.Audio("/sounds/notify.wav"),3)
    ding    = new lycopene.AudioWithLoop(new lycopene.Audio("/sounds/ding.wav"),3)
    current = ''

    clock = new lycopene.Clock((state,minute,second) ->
      if (current != state)
        $('#time').attr('class',state)
        $('#controller').html($('#' + state).html())

        switch state
          when 'working' then notify.play()
          when 'resting' then ding.play()

        current = state

      $('#minute').text(minute)
      $('#second').text(second)

      if (second == 30)
        controller.synchronize()
    )
    linkage = lycopene.io.connect('/')

    new lycopene.ClockController(linkage,clock)

  do ->
    connecting = $('#connecting')
    connecting.show()
    controller.ping( ->
      controller.synchronize()
      connecting.hide()
    )

  controller
