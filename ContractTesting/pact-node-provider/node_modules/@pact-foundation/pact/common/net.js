"use strict";
/**
 * Network module.
 * @module net
 * @private
 */
Object.defineProperty(exports, "__esModule", { value: true });
var net = require("net");
var isPortAvailable = function (port, host) {
    return new Promise(function (resolve, reject) {
        var server = net.createServer()
            .listen({ port: port, host: host, exclusive: true })
            .on("error", function (e) { return (e.code === "EADDRINUSE" ? reject(new Error("Port " + port + " is unavailable")) : reject(e)); })
            .on("listening", function () { return server.once("close", function () { return resolve(); }).close(); });
    });
};
exports.isPortAvailable = isPortAvailable;
//# sourceMappingURL=net.js.map