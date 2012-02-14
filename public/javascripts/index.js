(function() {

  module.exports.build = function(lycopene, $) {
    var controller, sound;
    sound = new lycopene.Audio("/sounds/notify.wav");
    controller = (function() {
      var clock, current, linkage, startRest, startWork;
      startWork = new lycopene.AudioWithLoop(sound, 3);
      startRest = new lycopene.AudioWithLoop(sound, 2);
      current = '';
      clock = new lycopene.Clock(function(scene) {
        var minute, second;
        second = ('0' + (scene.remain % 60)).slice(-2);
        minute = ('0' + ((scene.remain - (scene.remain % 60)) / 60)).slice(-2);
        if (current !== scene.state) {
          $('#time').attr('class', scene.state);
          $('#controller').html($('#' + scene.state).html());
          switch (scene.state) {
            case 'working':
              startWork.play();
              break;
            case 'resting':
              startRest.play();
          }
          $('#today').html(scene.today);
          $('#overall').html(scene.overall);
          current = scene.state;
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
