class AudioWithLoop
  constructor: (audio,times)->
    lap = 1

    @play = ->
      lap = 1
      audio.play()

    audio.addEventListener('ended', ->
      if (lap++ < times)
        audio.play()
    )

module.exports.AudioWithLoop = AudioWithLoop
