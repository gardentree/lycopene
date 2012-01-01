(function() {
  var BREAK_TIME, Binder, Clock, WORKING_TIME,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Binder = (function() {

    function Binder(linkage, clock, controller) {
      this.bind = __bind(this.bind, this);      this.linkage = linkage;
      this.clock = clock;
      this.controller = controller;
    }

    Binder.prototype.bind = function(name) {
      var _this = this;
      this.controller[name] = function() {
        return _this.linkage.emit('notify', {
          command: name
        });
      };
      return this.linkage.on(name, this.clock[name]);
    };

    return Binder;

  })();

  WORKING_TIME = 1500;

  BREAK_TIME = 300;

  Clock = (function() {

    function Clock(canvas) {
      this.draw = __bind(this.draw, this);
      this.beat = __bind(this.beat, this);
      this.stop = __bind(this.stop, this);
      this.start = __bind(this.start, this);      this.canvas = canvas;
      this.time = WORKING_TIME;
      this.working = true;
      this.draw();
    }

    Clock.prototype.start = function() {
      return this.timer = setInterval(this.beat, 1000);
    };

    Clock.prototype.stop = function() {
      return clearInterval(this.timer);
    };

    Clock.prototype.beat = function() {
      this.time--;
      if (this.time <= 0) {
        this.working = !this.working;
        if (this.working) {
          this.time = WORKING_TIME;
        } else {
          this.time = BREAK_TIME;
        }
      }
      return this.draw();
    };

    Clock.prototype.draw = function() {
      var minute, second;
      second = ('0' + (this.time % 60)).slice(-2);
      minute = ('0' + ((this.time - second) / 60)).slice(-2);
      this.canvas.empty();
      return this.canvas.append("<span>" + minute + "</span><span>:</span><span>" + second + "</span>");
    };

    return Clock;

  })();

  window.build = function(canvas) {
    var binder, clock, controller;
    clock = new Clock(canvas);
    controller = new Object();
    binder = new Binder(io.connect('/'), clock, controller);
    binder.bind('start');
    binder.bind('stop');
    return controller;
  };

}).call(this);
