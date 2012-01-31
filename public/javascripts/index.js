(function() {

  module.exports.build = function(lycopene, $) {
    var controller;
    controller = (function() {
      var clock, current, ding, linkage, notify;
      notify = new lycopene.AudioWithLoop(new lycopene.Audio("/sounds/notify.wav"), 3);
      ding = new lycopene.AudioWithLoop(new lycopene.Audio("/sounds/ding.wav"), 3);
      current = '';
      clock = new lycopene.Clock(function(state, minute, second) {
        if (current !== state) {
          $('#time').attr('class', state);
          $('#controller').html($('#' + state).html());
          switch (state) {
            case 'working':
              notify.play();
              break;
            case 'resting':
              ding.play();
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
