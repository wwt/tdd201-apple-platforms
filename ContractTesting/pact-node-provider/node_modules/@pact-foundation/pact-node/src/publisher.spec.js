"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var path = require("path");
var fs = require("fs");
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
var publisher_1 = require("./publisher");
var logger_1 = require("./logger");
var broker_mock_1 = require("../test/integration/broker-mock");
var rimraf = require("rimraf");
var mkdirp = require("mkdirp");
var expect = chai.expect;
chai.use(chaiAsPromised);
describe("Publish Spec", function () {
    var PORT = Math.floor(Math.random() * 999) + 9000;
    var pactFile = path.resolve(__dirname, "../test/integration/me-they-success.json");
    var server;
    var absolutePath;
    var relativePath;
    before(function () { return broker_mock_1.default(PORT).then(function (s) {
        logger_1.default.debug("Pact Broker Mock listening on port: " + PORT);
        server = s;
    }); });
    after(function () { return server.close(); });
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
        it("should fail with an Error when not given pactBroker", function () {
            expect(function () {
                publisher_1.default({
                    pactFilesOrDirs: [absolutePath],
                    consumerVersion: "1.0.0"
                });
            }).to.throw(Error);
        });
        it("should fail with an Error when not given consumerVersion", function () {
            expect(function () {
                publisher_1.default({
                    pactBroker: "http://localhost",
                    pactFilesOrDirs: [absolutePath]
                });
            }).to.throw(Error);
        });
        it("should fail with an error when not given pactFilesOrDirs", function () {
            expect(function () {
                publisher_1.default({
                    pactBroker: "http://localhost",
                    consumerVersion: "1.0.0"
                });
            }).to.throw(Error);
        });
        it("should fail with an Error when given Pact paths that do not exist", function () {
            expect(function () {
                publisher_1.default({
                    pactBroker: "http://localhost",
                    pactFilesOrDirs: ["test.json"],
                    consumerVersion: "1.0.0"
                });
            }).to.throw(Error);
        });
    });
    context("when valid options are set", function () {
        it("should return an absolute path when a relative one is given", function () {
            expect(publisher_1.default({
                pactBroker: "http://localhost",
                pactFilesOrDirs: [relativePath],
                consumerVersion: "1.0.0"
            }).options.pactFilesOrDirs[0]).to.be.equal(path.resolve(__dirname, "..", relativePath));
        });
        it("should return a Publisher object when given the correct arguments", function () {
            var p = publisher_1.default({
                pactBroker: "http://localhost",
                pactFilesOrDirs: [pactFile],
                consumerVersion: "1.0.0"
            });
            expect(p).to.be.ok;
            expect(p.publish).to.be.a("function");
        });
    });
});
//# sourceMappingURL=publisher.spec.js.map