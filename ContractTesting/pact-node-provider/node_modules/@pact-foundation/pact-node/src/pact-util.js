"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var cp = require("child_process");
var logger_1 = require("./logger");
var path = require("path");
var _ = require("underscore");
var checkTypes = require("check-types");
exports.DEFAULT_ARG = "DEFAULT";
var PactUtil = (function () {
    function PactUtil() {
    }
    PactUtil.createArgumentsFromObject = function (args, mappings) {
        return _.chain(args)
            .reduce(function (acc, value, key) {
            if (value && mappings[key]) {
                var mapping_1 = mappings[key];
                var f_1 = acc.push.bind(acc);
                if (mapping_1 === exports.DEFAULT_ARG) {
                    mapping_1 = "";
                    f_1 = acc.unshift.bind(acc);
                }
                _.map(checkTypes.array(value) ? value : [value], function (v) { return f_1([mapping_1, "'" + v + "'"]); });
            }
            return acc;
        }, [])
            .flatten()
            .compact()
            .value();
    };
    PactUtil.prototype.createArguments = function (args, mappings) {
        return _.chain(args instanceof Array ? args : [args]).map(function (x) { return PactUtil.createArgumentsFromObject(x, mappings); }).flatten().value();
    };
    Object.defineProperty(PactUtil.prototype, "cwd", {
        get: function () {
            return path.resolve(__dirname, "..");
        },
        enumerable: true,
        configurable: true
    });
    PactUtil.prototype.spawnBinary = function (command, args, argMapping) {
        if (args === void 0) { args = {}; }
        if (argMapping === void 0) { argMapping = {}; }
        var envVars = JSON.parse(JSON.stringify(process.env));
        delete envVars["RUBYGEMS_GEMDEPS"];
        var file;
        var opts = {
            cwd: this.cwd,
            detached: !this.isWindows(),
            env: envVars
        };
        var cmd = [command].concat(this.createArguments(args, argMapping)).join(" ");
        var spawnArgs;
        if (this.isWindows()) {
            file = "cmd.exe";
            spawnArgs = ["/s", "/c", cmd];
            opts.windowsVerbatimArguments = true;
        }
        else {
            cmd = "./" + cmd;
            file = "/bin/sh";
            spawnArgs = ["-c", cmd];
        }
        logger_1.default.debug("Starting pact binary with '" + _.flatten([file, args, JSON.stringify(opts)]) + "'");
        var instance = cp.spawn(file, spawnArgs, opts);
        instance.stdout.setEncoding("utf8");
        instance.stderr.setEncoding("utf8");
        instance.stdout.on("data", logger_1.default.debug.bind(logger_1.default));
        instance.stderr.on("data", logger_1.default.debug.bind(logger_1.default));
        instance.on("error", logger_1.default.error.bind(logger_1.default));
        instance.once("close", function (code) {
            if (code !== 0) {
                logger_1.default.warn("Pact exited with code " + code + ".");
            }
        });
        logger_1.default.info("Created '" + cmd + "' process with PID: " + instance.pid);
        return instance;
    };
    PactUtil.prototype.killBinary = function (binary) {
        if (binary) {
            var pid = binary.pid;
            logger_1.default.info("Removing Pact with PID: " + pid);
            binary.removeAllListeners();
            try {
                this.isWindows() ? cp.execSync("taskkill /f /t /pid " + pid) : process.kill(-pid, "SIGINT");
            }
            catch (e) {
                return false;
            }
        }
        return true;
    };
    PactUtil.prototype.isWindows = function (platform) {
        if (platform === void 0) { platform = process.platform; }
        return platform === "win32";
    };
    return PactUtil;
}());
exports.PactUtil = PactUtil;
exports.default = new PactUtil();
//# sourceMappingURL=pact-util.js.map