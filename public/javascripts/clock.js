(function() {
  var Binder, Clock,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Binder = (function() {

    function Binder(linkage, clock, controller) {
      this.bind = __bind(this.bind, this);      this.linkage = linkage;
      this.clock = clock;
      this.controller = controller;
    }

    Binder.prototype.bind = function(command) {
      var _this = this;
      this.controller[command] = function() {
        return _this.linkage.emit(command);
      };
      return this.linkage.on(command, this.clock[command]);
    };

    return Binder;

  })();

  Clock = (function() {

    function Clock(redraw) {
      this.draw = __bind(this.draw, this);
      this.beat = __bind(this.beat, this);
      this.synchronize = __bind(this.synchronize, this);
      this.pause = __bind(this.pause, this);
      this.start = __bind(this.start, this);      this.redraw = redraw;
      this.time = {
        state: 'pausing',
        remain: -1
      };
    }

    Clock.prototype.start = function(time) {
      this.time = time;
      if (!(this.timer != null)) return this.timer = setInterval(this.beat, 1000);
    };

    Clock.prototype.pause = function(time) {
      clearInterval(this.timer);
      this.timer = null;
      this.time = time;
      return this.draw();
    };

    Clock.prototype.synchronize = function(time) {
      this.time = time;
      return this.draw();
    };

    Clock.prototype.beat = function() {
      this.time.remain--;
      return this.draw();
    };

    Clock.prototype.draw = function() {
      var minute, second;
      second = ('0' + (this.time.remain % 60)).slice(-2);
      minute = ('0' + ((this.time.remain - second) / 60)).slice(-2);
      return this.redraw(this.time.state, minute, second);
    };

    return Clock;

  })();

  window.build = function(canvas) {
    var binder, clock, controller;
    clock = new Clock(canvas);
    controller = new Object();
    binder = new Binder(io.connect('/'), clock, controller);
    binder.bind('start');
    binder.bind('pause');
    binder.bind('synchronize');
    controller.synchronize();
    return controller;
  };

}).call(this);
