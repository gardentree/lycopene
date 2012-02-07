(function() {
  var Clock,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Clock = (function() {

    function Clock(redraw) {
      this.stopTimer = __bind(this.stopTimer, this);
      this.draw = __bind(this.draw, this);
      this.beat = __bind(this.beat, this);
      this.abort = __bind(this.abort, this);
      this.synchronize = __bind(this.synchronize, this);
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);      this.redraw = redraw;
      this.time = {
        state: 'ready',
        remain: -1
      };
    }

    Clock.prototype.start = function(time) {
      this.time = time;
      this.draw(this.time.state);
      if (!(this.timer != null)) return this.timer = setInterval(this.beat, 1000);
    };

    Clock.prototype.stop = function(time) {
      this.stopTimer();
      this.time = time;
      return this.draw('ready');
    };

    Clock.prototype.synchronize = function(time) {
      this.time = time;
      return this.draw(this.time.state);
    };

    Clock.prototype.abort = function() {
      this.stopTimer();
      return this.draw('abort');
    };

    Clock.prototype.beat = function() {
      this.time.remain--;
      return this.draw(this.time.state);
    };

    Clock.prototype.draw = function(state) {
      var minute, second;
      second = ('0' + (this.time.remain % 60)).slice(-2);
      minute = ('0' + ((this.time.remain - second) / 60)).slice(-2);
      return this.redraw(state, minute, second);
    };

    Clock.prototype.stopTimer = function() {
      clearInterval(this.timer);
      return this.timer = null;
    };

    return Clock;

  })();

  module.exports.Clock = Clock;

}).call(this);
