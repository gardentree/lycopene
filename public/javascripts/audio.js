(function() {
  var AudioWithLoop;

  AudioWithLoop = (function() {

    function AudioWithLoop(audio, times) {
      var lap;
      lap = 1;
      this.play = function() {
        lap = 1;
        return audio.play();
      };
      audio.addEventListener('ended', function() {
        if (lap++ < times) return audio.play();
      });
    }

    return AudioWithLoop;

  })();

  module.exports.AudioWithLoop = AudioWithLoop;

}).call(this);
