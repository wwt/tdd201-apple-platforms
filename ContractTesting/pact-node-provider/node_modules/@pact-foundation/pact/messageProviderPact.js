"use strict";
/**
 * @module Message
 */
var __assign = (this && this.__assign) || Object.assign || function(t) {
    for (var s, i = 1, n = arguments.length; i < n; i++) {
        s = arguments[i];
        for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
            t[p] = s[p];
    }
    return t;
};
Object.defineProperty(exports, "__esModule", { value: true });
var lodash_1 = require("lodash");
var verifier_1 = require("./dsl/verifier");
var logger_1 = require("./common/logger");
var pact_node_1 = require("@pact-foundation/pact-node");
var express = require("express");
var http = require("http");
var bodyParser = require("body-parser");
/**
 * A Message Provider is analagous to Consumer in the HTTP Interaction model.
 *
 * It is the initiator of an interaction, and expects something on the other end
 * of the interaction to respond - just in this case, not immediately.
 */
var MessageProviderPact = /** @class */ (function () {
    function MessageProviderPact(config) {
        this.config = config;
        this.state = {};
        if (config.logLevel && !lodash_1.isEmpty(config.logLevel)) {
            pact_node_1.default.logLevel(config.logLevel);
            logger_1.default.level(config.logLevel);
        }
        else {
            logger_1.default.level();
        }
    }
    /**
     * Verify a Message Provider.
     */
    MessageProviderPact.prototype.verify = function () {
        logger_1.default.info("Verifying message");
        // Start the verification CLI proxy server
        var app = this.setupProxyApplication();
        var server = this.setupProxyServer(app);
        // Run the verification once the proxy server is available
        return this.waitForServerReady(server)
            .then(this.runProviderVerification())
            .then(function (result) {
            server.close();
            return result;
        });
    };
    // Listens for the server start event
    // Converts event Emitter to a Promise
    MessageProviderPact.prototype.waitForServerReady = function (server) {
        return new Promise(function (resolve, reject) {
            server.on("listening", function () { return resolve(server); });
            server.on("error", function () { return reject(); });
        });
    };
    // Run the Verification CLI process
    MessageProviderPact.prototype.runProviderVerification = function () {
        var _this = this;
        return function (server) {
            var opts = __assign({}, lodash_1.omit(_this.config, "handlers"), { providerBaseUrl: "http://localhost:" + server.address().port });
            // Run verification
            return new verifier_1.Verifier().verifyProvider(opts);
        };
    };
    // Get the API handler for the verification CLI process to invoke on POST /*
    MessageProviderPact.prototype.setupVerificationHandler = function () {
        var _this = this;
        return function (req, res) {
            // Extract the message request from the API
            var message = req.body;
            // Invoke the handler, and return the JSON response body
            // wrapped in a Message
            _this.setupStates(message)
                .then(function () { return _this.findHandler(message); })
                .then(function (handler) { return handler(message); })
                .then(function (o) { return res.json({ contents: o }); })
                .catch(function (e) { return res.status(500).send(e); });
        };
    };
    // Get the Proxy we'll pass to the CLI for verification
    MessageProviderPact.prototype.setupProxyServer = function (app) {
        return http.createServer(app).listen();
    };
    // Get the Express app that will run on the HTTP Proxy
    MessageProviderPact.prototype.setupProxyApplication = function () {
        var app = express();
        app.use(bodyParser.json());
        app.use(bodyParser.urlencoded({ extended: true }));
        app.use(function (req, res, next) {
            res.header("Content-Type", "application/json; charset=utf-8");
            next();
        });
        // Proxy server will respond to Verifier process
        app.all("/*", this.setupVerificationHandler());
        return app;
    };
    // Lookup the handler based on the description, or get the default handler
    MessageProviderPact.prototype.setupStates = function (message) {
        var _this = this;
        var promises = new Array();
        if (message.providerStates) {
            message.providerStates.forEach(function (state) {
                var handler = _this.config.stateHandlers
                    ? _this.config.stateHandlers[state.name]
                    : null;
                if (handler) {
                    promises.push(handler(state.name));
                }
                else {
                    logger_1.default.warn("no state handler found for \"" + state.name + "\", ignorning");
                }
            });
        }
        return Promise.all(promises);
    };
    // Lookup the handler based on the description, or get the default handler
    MessageProviderPact.prototype.findHandler = function (message) {
        var handler = this.config.messageProviders[message.description || ""];
        if (!handler) {
            logger_1.default.warn("no handler found for message " + message.description);
            return Promise.reject("No handler found for message \"" + message.description + "\"." +
                " Check your \"handlers\" configuration");
        }
        return Promise.resolve(handler);
    };
    return MessageProviderPact;
}());
exports.MessageProviderPact = MessageProviderPact;
//# sourceMappingURL=messageProviderPact.js.map