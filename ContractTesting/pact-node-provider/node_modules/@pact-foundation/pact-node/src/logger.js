"use strict";
var _this = this;
Object.defineProperty(exports, "__esModule", { value: true });
var bunyan = require("bunyan");
var PrettyStream = require("bunyan-prettystream");
var pkg = require("../package.json");
var prettyStdOut = new PrettyStream();
prettyStdOut.pipe(process.stdout);
bunyan.prototype.time = function (action, startTime) {
    var time = Date.now() - startTime;
    _this.info({
        duration: time,
        action: action,
        type: "TIMER"
    }, "TIMER: " + action + " completed in " + time + " milliseconds");
};
bunyan.prototype.logLevelName = function () { return bunyan.nameFromLevel[_this.level()]; };
var Logger = new bunyan({
    name: "pact-node@" + pkg.version,
    streams: [{
            level: (process.env.LOGLEVEL || "info"),
            stream: prettyStdOut,
            type: "raw"
        }]
});
exports.default = Logger;
//# sourceMappingURL=logger.js.map