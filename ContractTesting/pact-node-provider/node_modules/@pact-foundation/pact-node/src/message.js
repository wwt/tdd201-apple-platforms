"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var q = require("q");
var logger_1 = require("./logger");
var pact_util_1 = require("./pact-util");
var pact_standalone_1 = require("./pact-standalone");
var path = require("path");
var mkdirp = require("mkdirp");
var checkTypes = require("check-types");
var Message = (function () {
    function Message(options) {
        this.__argMapping = {
            "content": pact_util_1.DEFAULT_ARG,
            "pactFileWriteMode": pact_util_1.DEFAULT_ARG,
            "dir": "--pact_dir",
            "consumer": "--consumer",
            "provider": "--provider",
            "spec": "--pact_specification_version",
        };
        options = options || {};
        options.pactFileWriteMode = options.pactFileWriteMode || "update";
        options.spec = options.spec || 3;
        checkTypes.assert.nonEmptyString(options.consumer, "Must provide the consumer name");
        checkTypes.assert.nonEmptyString(options.provider, "Must provide the provider name");
        checkTypes.assert.nonEmptyString(options.content, "Must provide message content");
        checkTypes.assert.nonEmptyString(options.dir, "Must provide pact output dir");
        if (options.spec) {
            checkTypes.assert.number(options.spec);
            checkTypes.assert.integer(options.spec);
            checkTypes.assert.positive(options.spec);
        }
        if (options.dir) {
            options.dir = path.resolve(options.dir);
            try {
                fs.statSync(options.dir).isDirectory();
            }
            catch (e) {
                mkdirp.sync(options.dir);
            }
        }
        if (options.content) {
            try {
                JSON.parse(options.content);
            }
            catch (e) {
                throw new Error("Unable to parse message content to JSON, invalid json supplied");
            }
        }
        if (options.consumer) {
            checkTypes.assert.string(options.consumer);
        }
        if (options.provider) {
            checkTypes.assert.string(options.provider);
        }
        checkTypes.assert.includes(["overwrite", "update", "merge"], options.pactFileWriteMode);
        if ((options.pactBrokerUsername && !options.pactBrokerPassword) || (options.pactBrokerPassword && !options.pactBrokerUsername)) {
            throw new Error("Must provide both Pact Broker username and password. None needed if authentication on Broker is disabled.");
        }
        this.options = options;
    }
    Message.prototype.createMessage = function () {
        logger_1.default.info("Creating message pact");
        var deferred = q.defer();
        var instance = pact_util_1.default.spawnBinary("" + pact_standalone_1.default.messagePath, this.options, this.__argMapping);
        var output = [];
        instance.stdout.on("data", function (l) { return output.push(l); });
        instance.stderr.on("data", function (l) { return output.push(l); });
        instance.once("close", function (code) {
            var o = output.join("\n");
            logger_1.default.info(o);
            if (code === 0) {
                return deferred.resolve(o);
            }
            else {
                return deferred.reject(o);
            }
        });
        return deferred.promise;
    };
    return Message;
}());
exports.Message = Message;
exports.default = (function (options) { return new Message(options); });
//# sourceMappingURL=message.js.map