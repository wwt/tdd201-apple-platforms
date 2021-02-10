"use strict";
/**
 * @module Message
 */
Object.defineProperty(exports, "__esModule", { value: true });
var lodash_1 = require("lodash");
var matchers_1 = require("./dsl/matchers");
var utils_1 = require("./common/utils");
var logger_1 = require("./common/logger");
var pact_node_1 = require("@pact-foundation/pact-node");
/**
 * A Message Consumer is analagous to a Provider in the HTTP Interaction model.
 * It is the receiver of an interaction, and needs to be able to handle whatever
 * request was provided.
 */
var MessageConsumerPact = /** @class */ (function () {
    function MessageConsumerPact(config) {
        this.config = config;
        // Build up a valid Message object
        this.state = {};
        if (!lodash_1.isEmpty(config.logLevel)) {
            pact_node_1.default.logLevel(config.logLevel);
        }
    }
    /**
     * Gives a state the provider should be in for this Message.
     *
     * @param {string} providerState - The state of the provider.
     * @returns {Message} MessageConsumer
     */
    MessageConsumerPact.prototype.given = function (providerState) {
        if (providerState) {
            // Currently only supports a single state
            // but the format needs to be v3 compatible for
            // basic interoperability
            this.state.providerStates = [
                {
                    name: providerState,
                },
            ];
        }
        return this;
    };
    /**
     * A free style description of the Message.
     *
     * @param {string} description - A description of the Message to be received
     * @returns {Message} MessageConsumer
     */
    MessageConsumerPact.prototype.expectsToReceive = function (description) {
        if (lodash_1.isEmpty(description)) {
            throw new Error("You must provide a description for the Message.");
        }
        this.state.description = description;
        return this;
    };
    /**
     * The content to be received by the message consumer.
     *
     * May be a JSON document or JSON primitive.
     *
     * @param {string} content - A description of the Message to be received
     * @returns {Message} MessageConsumer
     */
    MessageConsumerPact.prototype.withContent = function (content) {
        if (lodash_1.isEmpty(content)) {
            throw new Error("You must provide a valid JSON document or primitive for the Message.");
        }
        this.state.contents = content;
        return this;
    };
    /**
     * Message metadata
     *
     * @param {string} metadata -
     * @returns {Message} MessageConsumer
     */
    MessageConsumerPact.prototype.withMetadata = function (metadata) {
        if (lodash_1.isEmpty(metadata)) {
            throw new Error("You must provide valid metadata for the Message, or none at all");
        }
        this.state.metadata = metadata;
        return this;
    };
    /**
     * Returns the Message object created.
     *
     * @returns {Message}
     */
    MessageConsumerPact.prototype.json = function () {
        return this.state;
    };
    /**
     * Creates a new Pact _message_ interaction to build a testable interaction.
     *
     * @param handler A message handler, that must be able to consume the given Message
     * @returns {Promise}
     */
    MessageConsumerPact.prototype.verify = function (handler) {
        var _this = this;
        logger_1.default.info("Verifying message");
        return this.validate()
            .then(function () { return handler(matchers_1.extractPayload(lodash_1.cloneDeep(_this.state))); })
            .then(function () {
            return utils_1.qToPromise(_this.getServiceFactory().createMessage({
                consumer: _this.config.consumer,
                content: JSON.stringify(_this.state),
                dir: _this.config.dir,
                pactFileWriteMode: _this.config.pactfileWriteMode,
                provider: _this.config.provider,
                spec: 3,
            }));
        });
    };
    /**
     * Validates the current state of the Message.
     *
     * @returns {Promise}
     */
    MessageConsumerPact.prototype.validate = function () {
        if (isMessage(this.state)) {
            return Promise.resolve();
        }
        return Promise.reject("message has not yet been properly constructed");
    };
    MessageConsumerPact.prototype.getServiceFactory = function () {
        return pact_node_1.default;
    };
    return MessageConsumerPact;
}());
exports.MessageConsumerPact = MessageConsumerPact;
var isMessage = function (x) {
    return x.contents !== undefined;
};
// TODO: create basic adapters for API handlers, e.g.
// bodyHandler takes a synchronous function and returns
// a wrapped function that accepts a Message and returns a Promise
function synchronousBodyHandler(handler) {
    return function (m) {
        var body = m.contents;
        return new Promise(function (resolve, reject) {
            try {
                var res = handler(body);
                resolve(res);
            }
            catch (e) {
                reject(e);
            }
        });
    };
}
exports.synchronousBodyHandler = synchronousBodyHandler;
// bodyHandler takes an asynchronous (promisified) function and returns
// a wrapped function that accepts a Message and returns a Promise
// TODO: move this into its own package and re-export?
function asynchronousBodyHandler(handler) {
    return function (m) { return handler(m.contents); };
}
exports.asynchronousBodyHandler = asynchronousBodyHandler;
//# sourceMappingURL=messageConsumerPact.js.map