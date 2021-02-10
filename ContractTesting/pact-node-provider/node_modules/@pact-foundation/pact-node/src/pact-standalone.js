"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var path = require("path");
var install_1 = require("../standalone/install");
var pact_util_1 = require("./pact-util");
exports.standalone = function (platform, arch) {
    platform = platform || process.platform;
    arch = arch || process.arch;
    var binName = function (name) { return "" + name + (pact_util_1.default.isWindows(platform) ? ".bat" : ""); };
    var mock = binName("pact-mock-service");
    var message = binName("pact-message");
    var verify = binName("pact-provider-verifier");
    var broker = binName("pact-broker");
    var stub = binName("pact-stub-service");
    var basePath = path.join("standalone", install_1.getBinaryEntry(platform, arch).folderName, "bin");
    return {
        cwd: pact_util_1.default.cwd,
        brokerPath: path.join(basePath, broker),
        brokerFullPath: path.resolve(pact_util_1.default.cwd, basePath, broker).trim(),
        messagePath: path.join(basePath, message),
        messageFullPath: path.resolve(pact_util_1.default.cwd, basePath, message).trim(),
        mockServicePath: path.join(basePath, mock),
        mockServiceFullPath: path.resolve(pact_util_1.default.cwd, basePath, mock).trim(),
        stubPath: path.join(basePath, stub),
        stubFullPath: path.resolve(pact_util_1.default.cwd, basePath, stub).trim(),
        verifierPath: path.join(basePath, verify),
        verifierFullPath: path.resolve(pact_util_1.default.cwd, basePath, verify).trim()
    };
};
exports.default = exports.standalone();
//# sourceMappingURL=pact-standalone.js.map