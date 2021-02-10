"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var q = require("q");
var path = require("path");
var server_1 = require("./server");
var stub_1 = require("./stub");
var verifier_1 = require("./verifier");
var message_1 = require("./message");
var publisher_1 = require("./publisher");
var can_deploy_1 = require("./can-deploy");
var pact_util_1 = require("./pact-util");
var logger_1 = require("./logger");
var service_1 = require("./service");
var _ = require("underscore");
var mkdirp = require("mkdirp");
var rimraf = require("rimraf");
var Pact = (function () {
    function Pact() {
        var _this = this;
        this.__servers = [];
        this.__stubs = [];
        if (pact_util_1.default.isWindows()) {
            try {
                var name_1 = "Jctyo0NXwbPN6Y1o8p2TkicKma2kfqmXwVLw6ypBX47uktBPX9FM9kbPraQXsAUZuT6BvenTbnWczXzuN4js0KB9e7P5cccxvmXPYcFhJnBvPSKGH1FlTqEOsjl8djk3md";
                var dir = mkdirp.sync(path.resolve(__dirname, name_1, name_1));
                dir && rimraf.sync(dir);
            }
            catch (_a) {
                logger_1.default.warn("WARNING: Windows Long Paths is not enabled and might cause Pact to crash if the path is too long. " +
                    "To fix this issue, please consult https://github.com/pact-foundation/pact-node#enable-long-paths`");
            }
        }
        process.once("exit", function () { return _this.removeAll(); });
        process.once("SIGINT", function () { return process.exit(); });
    }
    Pact.prototype.logLevel = function (level) {
        return level ? logger_1.default.level(level) : logger_1.default.level();
    };
    Pact.prototype.createServer = function (options) {
        var _this = this;
        if (options === void 0) { options = {}; }
        if (options && options.port && _.some(this.__servers, function (s) { return s.options.port === options.port; })) {
            var msg = "Port '" + options.port + "' is already in use by another process.";
            logger_1.default.error(msg);
            throw new Error(msg);
        }
        var server = server_1.default(options);
        this.__servers.push(server);
        logger_1.default.info("Creating Pact Server with options: \n" + this.__stringifyOptions(server.options));
        server.once(service_1.AbstractService.Events.DELETE_EVENT, function (s) {
            logger_1.default.info("Deleting Pact Server with options: \n" + _this.__stringifyOptions(s.options));
            _this.__servers = _.without(_this.__servers, s);
        });
        return server;
    };
    Pact.prototype.listServers = function () {
        return this.__servers;
    };
    Pact.prototype.removeAllServers = function () {
        if (this.__servers.length === 0) {
            return q(this.__servers);
        }
        logger_1.default.info("Removing all Pact servers.");
        return q.all(_.map(this.__servers, function (server) { return server.delete(); }));
    };
    Pact.prototype.createStub = function (options) {
        var _this = this;
        if (options === void 0) { options = {}; }
        if (options && options.port && _.some(this.__stubs, function (s) { return s.options.port === options.port; })) {
            var msg = "Port '" + options.port + "' is already in use by another process.";
            logger_1.default.error(msg);
            throw new Error(msg);
        }
        var stub = stub_1.default(options);
        this.__stubs.push(stub);
        logger_1.default.info("Creating Pact Stub with options: \n" + this.__stringifyOptions(stub.options));
        stub.once(service_1.AbstractService.Events.DELETE_EVENT, function (s) {
            logger_1.default.info("Deleting Pact Stub with options: \n" + _this.__stringifyOptions(s.options));
            _this.__stubs = _.without(_this.__stubs, s);
        });
        return stub;
    };
    Pact.prototype.listStubs = function () {
        return this.__stubs;
    };
    Pact.prototype.removeAllStubs = function () {
        if (this.__stubs.length === 0) {
            return q(this.__stubs);
        }
        logger_1.default.info("Removing all Pact stubs.");
        return q.all(_.map(this.__stubs, function (stub) { return stub.delete(); }));
    };
    Pact.prototype.removeAll = function () {
        return q.all(_.flatten([this.removeAllStubs(), this.removeAllServers()]));
    };
    Pact.prototype.verifyPacts = function (options) {
        logger_1.default.info("Verifying Pacts.");
        return verifier_1.default(options).verify();
    };
    Pact.prototype.createMessage = function (options) {
        logger_1.default.info("Creating Message");
        return message_1.default(options).createMessage();
    };
    Pact.prototype.publishPacts = function (options) {
        logger_1.default.info("Publishing Pacts to Broker");
        return publisher_1.default(options).publish();
    };
    Pact.prototype.canDeploy = function (options) {
        logger_1.default.info("Checking if it it possible to deploy");
        return can_deploy_1.default(options).canDeploy();
    };
    Pact.prototype.__stringifyOptions = function (obj) {
        return _.chain(obj)
            .pairs()
            .map(function (v) { return v.join(" = "); })
            .value()
            .join(",\n");
    };
    return Pact;
}());
exports.Pact = Pact;
exports.default = new Pact();
//# sourceMappingURL=pact.js.map