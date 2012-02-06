(function() {

  module.exports.build = function(lycopene, $) {
    var controller, sound;
    sound = new lycopene.Audio("/sounds/notify.wav");
    controller = (function() {
      var clock, current, linkage, startRest, startWork;
      startWork = new lycopene.AudioWithLoop(sound, 3);
      startRest = new lycopene.AudioWithLoop(sound, 2);
      current = '';
      clock = new lycopene.Clock(function(state, minute, second) {
        if (current !== state) {
          $('#time').attr('class', state);
          $('#controller').html($('#' + state).html());
          switch (state) {
            case 'working':
              startWork.play();
              break;
            case 'resting':
              startRest.play();
          }
          current = state;
        }
        $('#minute').text(minute);
        $('#second').text(second);
        if (second === 30) return controller.synchronize();
      });
      linkage = lycopene.io.connect('/');
      return new lycopene.ClockController(linkage, clock);
    })();
    controller.prepare = function() {
      return sound.load();
    };
    (function() {
      var connecting;
      connecting = $('#connecting');
      connecting.show();
      return controller.ping(function() {
        controller.synchronize();
        return connecting.hide();
      });
    })();
    return controller;
  };

}).call(this);
