module.exports.build = (lycopene,$)->
  sound = new lycopene.Audio("/sounds/notify.wav")
  controller = do ->
    startWork = new lycopene.AudioWithLoop(sound,3)
    startRest = new lycopene.AudioWithLoop(sound,2)
    current = ''

    clock = new lycopene.Clock((state,minute,second) ->
      if (current != state)
        $('#time').attr('class',state)
        $('#controller').html($('#' + state).html())

        switch state
          when 'working' then startWork.play()
          when 'resting' then startRest.play()

        current = state

      $('#minute').text(minute)
      $('#second').text(second)

      if (second == 30)
        controller.synchronize()
    )
    linkage = lycopene.io.connect('/')

    new lycopene.ClockController(linkage,clock)
  controller.prepare = ->
    sound.load()

  do ->
    connecting = $('#connecting')
    connecting.show()
    controller.ping( ->
      controller.synchronize()
      connecting.hide()
    )

  controller
