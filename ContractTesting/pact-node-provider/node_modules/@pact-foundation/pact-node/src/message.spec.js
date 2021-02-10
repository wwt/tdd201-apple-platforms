"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chai = require("chai");
var path = require("path");
var chaiAsPromised = require("chai-as-promised");
var fs = require("fs");
var message_1 = require("./message");
var mkdirp = require("mkdirp");
var rimraf = require("rimraf");
var expect = chai.expect;
chai.use(chaiAsPromised);
describe("Message Spec", function () {
    var validJSON = "{ \"description\": \"a test mesage\", \"content\": { \"name\": \"Mary\" } }";
    var absolutePath;
    var relativePath;
    beforeEach(function () {
        relativePath = ".tmp/" + Math.floor(Math.random() * 1000);
        absolutePath = path.resolve(__dirname, "..", relativePath);
        mkdirp.sync(absolutePath);
    });
    afterEach(function () {
        if (fs.existsSync(absolutePath)) {
            rimraf.sync(absolutePath);
        }
    });
    context("when invalid options are set", function () {
        it("should throw an Error when not given any message content", function () {
            expect(function () { return message_1.default({
                consumer: "a-consumer",
                dir: absolutePath
            }); }).to.throw(Error);
        });
        it("should throw an Error when not given a consumer", function () {
            expect(function () { return message_1.default({
                provider: "a-provider",
                dir: absolutePath,
                content: validJSON
            }); }).to.throw(Error);
        });
        it("should throw an Error when not given a provider", function () {
            expect(function () { return message_1.default({
                consumer: "a-provider",
                dir: absolutePath,
                content: validJSON
            }); }).to.throw(Error);
        });
        it("should throw an Error when given an invalid JSON document", function () {
            expect(function () { return message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: absolutePath,
                content: "{ \"unparseable\" }"
            }); }).to.throw(Error);
        });
        it("should throw an Error when not given a pact dir", function () {
            expect(function () { return message_1.default({
                consumer: "a-consumer",
                content: validJSON
            }); }).to.throw(Error);
        });
    });
    context("when valid options are set", function () {
        it("should return a message object when given the correct arguments", function () {
            var message = message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: absolutePath,
                content: validJSON
            });
            expect(message).to.be.a("object");
            expect(message).to.respondTo("createMessage");
        });
        it("should return a promise when calling createMessage", function () {
            var promise = message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: absolutePath,
                content: validJSON
            }).createMessage();
            expect(promise).to.ok;
            return expect(promise).to.eventually.be.fulfilled;
        });
        it("should create a new directory if the directory specified doesn't exist yet", function () {
            var dir = path.resolve(absolutePath, "create");
            return message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: dir,
                content: validJSON
            })
                .createMessage()
                .then(function () { return expect(fs.existsSync(dir)).to.be.true; });
        });
        it("should return an absolute path when a relative one is given", function () {
            var dir = path.join(relativePath, "create");
            expect(message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: dir,
                content: validJSON
            }).options.dir).to.equal(path.resolve(__dirname, "..", dir));
        });
        it("should create a new directory with a relative path", function () {
            var dir = path.join(relativePath, "create");
            return message_1.default({
                consumer: "some-consumer",
                provider: "a-provider",
                dir: dir,
                content: validJSON
            })
                .createMessage()
                .then(function () { return expect(fs.existsSync(path.resolve(__dirname, "..", dir))).to.be.true; });
        });
    });
});
//# sourceMappingURL=message.spec.js.map