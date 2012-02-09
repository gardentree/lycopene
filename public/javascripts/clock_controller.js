(function() {
  var Binder, ClockController,
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

  ClockController = (function() {

    function ClockController(linkage, clock) {
      var binder,
        _this = this;
      binder = new Binder(linkage, clock, this);
      binder.bind('start');
      binder.bind('stop');
      binder.bind('pause');
      binder.bind('synchronize');
      this.ping = function(callback) {
        linkage.on('ping', callback);
        return linkage.emit('ping');
      };
      linkage.on('disconnect', function() {
        return clock.abort();
      });
    }

    return ClockController;

  })();

  module.exports.ClockController = ClockController;

}).call(this);
