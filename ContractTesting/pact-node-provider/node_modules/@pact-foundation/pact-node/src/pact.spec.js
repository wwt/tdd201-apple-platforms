"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chai = require("chai");
var path = require("path");
var chaiAsPromised = require("chai-as-promised");
var fs = require("fs");
var pact_1 = require("./pact");
var expect = chai.expect;
chai.use(chaiAsPromised);
describe("Pact Spec", function () {
    afterEach(function () { return pact_1.default.removeAllServers(); });
    describe("Set Log Level", function () {
        var originalLogLevel;
        before(function () { return originalLogLevel = pact_1.default.logLevel(); });
        after(function () { return pact_1.default.logLevel(originalLogLevel); });
        context("when setting a log level", function () {
            it("should be able to set log level 'trace'", function () {
                pact_1.default.logLevel("trace");
                expect(pact_1.default.logLevel()).to.be.equal(10);
            });
            it("should be able to set log level 'debug'", function () {
                pact_1.default.logLevel("debug");
                expect(pact_1.default.logLevel()).to.be.equal(20);
            });
            it("should be able to set log level 'info'", function () {
                pact_1.default.logLevel("info");
                expect(pact_1.default.logLevel()).to.be.equal(30);
            });
            it("should be able to set log level 'warn'", function () {
                pact_1.default.logLevel("warn");
                expect(pact_1.default.logLevel()).to.be.equal(40);
            });
            it("should be able to set log level 'error'", function () {
                pact_1.default.logLevel("error");
                expect(pact_1.default.logLevel()).to.be.equal(50);
            });
            it("should be able to set log level 'fatal'", function () {
                pact_1.default.logLevel("fatal");
                expect(pact_1.default.logLevel()).to.be.equal(60);
            });
        });
    });
    describe("Create serverFactory", function () {
        var dirPath;
        var monkeypatchFile = path.resolve(__dirname, "../test/monkeypatch.rb");
        beforeEach(function () { return dirPath = path.resolve(__dirname, "../.tmp/" + Math.floor(Math.random() * 1000)); });
        afterEach(function () {
            try {
                if (fs.statSync(dirPath).isDirectory()) {
                    fs.rmdirSync(dirPath);
                }
            }
            catch (e) {
            }
        });
        context("when no options are set", function () {
            it("should use defaults and return serverFactory", function () {
                var server = pact_1.default.createServer();
                expect(server).to.be.an("object");
                expect(server.options).to.be.an("object");
                expect(server.options).to.contain.all.keys(["cors", "ssl", "host", "dir"]);
                expect(server.start).to.be.a("function");
                expect(server.stop).to.be.a("function");
                expect(server.delete).to.be.a("function");
            });
        });
        context("when user specifies valid options", function () {
            it("should return serverFactory using specified options", function () {
                var options = {
                    port: 9500,
                    host: "localhost",
                    dir: dirPath,
                    ssl: true,
                    cors: true,
                    log: "log.txt",
                    spec: 1,
                    consumer: "consumerName",
                    provider: "providerName",
                    monkeypatch: monkeypatchFile
                };
                var server = pact_1.default.createServer(options);
                expect(server).to.be.an("object");
                expect(server.options).to.be.an("object");
                expect(server.options.port).to.equal(options.port);
                expect(server.options.host).to.equal(options.host);
                expect(server.options.dir).to.equal(options.dir);
                expect(server.options.ssl).to.equal(options.ssl);
                expect(server.options.cors).to.equal(options.cors);
                expect(server.options.log).to.equal(options.log);
                expect(server.options.spec).to.equal(options.spec);
                expect(server.options.consumer).to.equal(options.consumer);
                expect(server.options.provider).to.equal(options.provider);
                expect(server.options.monkeypatch).to.equal(options.monkeypatch);
            });
        });
        context("when user specifies invalid port", function () {
            it("should return an error on negative port number", function () {
                expect(function () { return pact_1.default.createServer({ port: -42 }); }).to.throw(Error);
            });
            it("should return an error on non-integer", function () {
                expect(function () {
                    pact_1.default.createServer({ port: 42.42 });
                }).to.throw(Error);
            });
            it("should return an error on non-number", function () {
                expect(function () { return pact_1.default.createServer({ port: "99" }); }).to.throw(Error);
            });
            it("should return an error on outside port range", function () {
                expect(function () {
                    pact_1.default.createServer({ port: 99999 });
                }).to.throw(Error);
            });
        });
        context("when user specifies port that's currently in use", function () {
            it("should return a port conflict error", function () {
                pact_1.default.createServer({ port: 5100 });
                expect(function () { return pact_1.default.createServer({ port: 5100 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid host", function () {
            it("should return an error on non-string", function () {
                expect(function () { return pact_1.default.createServer({ host: 12 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid pact directory", function () {
            it("should create the directory for us", function () {
                pact_1.default.createServer({ dir: dirPath });
                expect(fs.statSync(dirPath).isDirectory()).to.be.true;
            });
        });
        context("when user specifies invalid ssl", function () {
            it("should return an error on non-boolean", function () {
                expect(function () { return pact_1.default.createServer({ ssl: 1 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid cors", function () {
            it("should return an error on non-boolean", function () {
                expect(function () { return pact_1.default.createServer({ cors: 1 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid spec", function () {
            it("should return an error on non-number", function () {
                expect(function () { return pact_1.default.createServer({ spec: "1" }); }).to.throw(Error);
            });
            it("should return an error on negative number", function () {
                expect(function () {
                    pact_1.default.createServer({ spec: -12 });
                }).to.throw(Error);
            });
            it("should return an error on non-integer", function () {
                expect(function () {
                    pact_1.default.createServer({ spec: 3.14 });
                }).to.throw(Error);
            });
        });
        context("when user specifies invalid consumer name", function () {
            it("should return an error on non-string", function () {
                expect(function () { return pact_1.default.createServer({ consumer: 1234 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid provider name", function () {
            it("should return an error on non-string", function () {
                expect(function () { return pact_1.default.createServer({ provider: 2341 }); }).to.throw(Error);
            });
        });
        context("when user specifies invalid monkeypatch", function () {
            it("should return an error on invalid path", function () {
                expect(function () {
                    pact_1.default.createServer({ monkeypatch: "some-ruby-file.rb" });
                }).to.throw(Error);
            });
        });
    });
    describe("List servers", function () {
        context("when called and there are no servers", function () {
            it("should return an empty list", function () {
                expect(pact_1.default.listServers()).to.be.empty;
            });
        });
        context("when called and there are servers in list", function () {
            it("should return a list of all servers", function () {
                pact_1.default.createServer({ port: 1234 });
                pact_1.default.createServer({ port: 1235 });
                pact_1.default.createServer({ port: 1236 });
                expect(pact_1.default.listServers()).to.have.length(3);
            });
        });
        context("when server is removed", function () {
            it("should update the list", function () {
                pact_1.default.createServer({ port: 1234 });
                pact_1.default.createServer({ port: 1235 });
                return pact_1.default.createServer({ port: 1236 })
                    .delete()
                    .then(function () { return expect(pact_1.default.listServers()).to.have.length(2); });
            });
        });
    });
    describe("Remove all servers", function () {
        context("when removeAll() is called and there are servers to remove", function () {
            it("should remove all servers", function () {
                pact_1.default.createServer({ port: 1234 });
                pact_1.default.createServer({ port: 1235 });
                pact_1.default.createServer({ port: 1236 });
                return pact_1.default.removeAllServers()
                    .then(function () { return expect(pact_1.default.listServers()).to.be.empty; });
            });
        });
    });
});
//# sourceMappingURL=pact.spec.js.map