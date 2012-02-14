module.exports.build = (lycopene,$)->
  sound = new lycopene.Audio("/sounds/notify.wav")
  controller = do ->
    startWork = new lycopene.AudioWithLoop(sound,3)
    startRest = new lycopene.AudioWithLoop(sound,2)
    current = ''

    clock = new lycopene.Clock((scene) ->
      second = ('0' + (scene.remain % 60)).slice(-2)
      minute = ('0' + ((scene.remain - (scene.remain % 60)) / 60)).slice(-2)

      if (current != scene.state)
        $('#time').attr('class',scene.state)
        $('#controller').html($('#' + scene.state).html())

        switch scene.state
          when 'working' then startWork.play()
          when 'resting' then startRest.play()

        $('#today').html(scene.today)
        $('#overall').html(scene.overall)

        current = scene.state

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
