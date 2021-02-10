"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var server_1 = require("./server");
var chai = require("chai");
var chaiAsPromised = require("chai-as-promised");
var fs = require("fs");
var path = require("path");
var q = require("q");
var _ = require("underscore");
var mkdirp = require("mkdirp");
var rimraf = require("rimraf");
chai.use(chaiAsPromised);
var expect = chai.expect;
describe("Server Spec", function () {
    var server;
    var monkeypatchFile = path.resolve(__dirname, "../test/monkeypatch.rb");
    afterEach(function () { return server ? server.delete() : null; });
    var absolutePath;
    var relativePath;
    var relativeSSLCertPath = "test/ssl/server.crt";
    var absoluteSSLCertPath = path.resolve(__dirname, "..", relativeSSLCertPath);
    var relativeSSLKeyPath = "test/ssl/server.key";
    var absoluteSSLKeyPath = path.resolve(__dirname, "..", relativeSSLKeyPath);
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
    describe("Start server", function () {
        context("when no options are set", function () {
            it("should start correctly with defaults", function () {
                server = server_1.default();
                return expect(server.start()).to.eventually.be.fulfilled;
            });
        });
        context("when invalid options are set", function () {
            it("should fail if custom ssl certs do not exist", function () {
                expect(function () { return server_1.default({
                    ssl: true,
                    sslcert: "does/not/exist",
                    sslkey: absoluteSSLKeyPath
                }); }).to.throw(Error);
            });
            it("should fail if custom ssl keys do not exist", function () {
                expect(function () { return server_1.default({
                    ssl: true,
                    sslcert: absoluteSSLCertPath,
                    sslkey: "does/not/exist"
                }); }).to.throw(Error);
            });
            it("should fail if custom ssl cert is set, but ssl key isn't", function () {
                expect(function () { return server_1.default({
                    ssl: true,
                    sslcert: absoluteSSLCertPath
                }); }).to.throw(Error);
            });
            it("should fail if custom ssl key is set, but ssl cert isn't", function () {
                expect(function () { return server_1.default({
                    ssl: true,
                    sslkey: absoluteSSLKeyPath
                }); }).to.throw(Error);
            });
            it("should fail if incorrect pactFileWriteMode provided", function () {
                expect(function () { return server_1.default({
                    pactFileWriteMode: "notarealoption",
                }); }).to.throw(Error);
            });
            it("should fail if incorrect logLevel provided", function () {
                expect(function () { return server_1.default({
                    logLevel: "nolog",
                }); }).to.throw(Error);
            });
        });
        context("when valid options are set", function () {
            it("should start correctly when instance is delayed", function () {
                server = server_1.default();
                var waitForServerUp = server["__waitForServiceUp"].bind(server);
                return q.allSettled([
                    waitForServerUp(server.options),
                    q.delay(5000).then(function () { return server.start(); })
                ]).then(function (results) { return expect(_.reduce(results, function (m, r) { return m && r.state === "fulfilled"; })).to.be.true; });
            });
            it("should start correctly with ssl", function () {
                server = server_1.default({ ssl: true });
                expect(server.options.ssl).to.equal(true);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with custom ssl cert/key", function () {
                server = server_1.default({
                    ssl: true,
                    sslcert: absoluteSSLCertPath,
                    sslkey: absoluteSSLKeyPath
                });
                expect(server.options.ssl).to.equal(true);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with custom ssl cert/key but without specifying ssl flag", function () {
                server = server_1.default({
                    sslcert: absoluteSSLCertPath,
                    sslkey: absoluteSSLKeyPath
                });
                expect(server.options.ssl).to.equal(true);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with cors", function () {
                server = server_1.default({ cors: true });
                expect(server.options.cors).to.equal(true);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with port", function () {
                var port = Math.floor(Math.random() * 999) + 9000;
                server = server_1.default({ port: port });
                expect(server.options.port).to.equal(port);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with host", function () {
                var host = "localhost";
                server = server_1.default({ host: host });
                expect(server.options.host).to.equal(host);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with spec version 1", function () {
                server = server_1.default({ spec: 1 });
                expect(server.options.spec).to.equal(1);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with spec version 2", function () {
                server = server_1.default({ spec: 2 });
                expect(server.options.spec).to.equal(2);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with log", function () {
                var logPath = path.resolve(absolutePath, "log.txt");
                server = server_1.default({ log: logPath });
                expect(server.options.log).to.equal(logPath);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with consumer name", function () {
                var consumerName = "cName";
                server = server_1.default({ consumer: consumerName });
                expect(server.options.consumer).to.equal(consumerName);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with provider name", function () {
                var providerName = "pName";
                server = server_1.default({ provider: providerName });
                expect(server.options.provider).to.equal(providerName);
                return expect(server.start()).to.eventually.be.fulfilled;
            });
            it("should start correctly with monkeypatch", function () {
                var s = server_1.default({ monkeypatch: monkeypatchFile });
                expect(s.options.monkeypatch).to.equal(monkeypatchFile);
                return expect(s.start()).to.eventually.be.fulfilled;
            });
            context("Paths", function () {
                it("should start correctly with dir, absolute path", function () {
                    server = server_1.default({ dir: relativePath });
                    expect(server.options.dir).to.equal(absolutePath);
                    return expect(server.start()).to.eventually.be.fulfilled;
                });
                it("should start correctly with log, relative paths", function () {
                    var logPath = path.join(relativePath, "log.txt");
                    server = server_1.default({ log: logPath });
                    expect(server.options.log).to.equal(path.resolve(logPath));
                    return expect(server.start()).to.eventually.be.fulfilled;
                });
                it("should start correctly with custom ssl cert/key, relative paths", function () {
                    server = server_1.default({
                        sslcert: relativeSSLCertPath,
                        sslkey: relativeSSLKeyPath
                    });
                    expect(server.options.sslcert).to.equal(absoluteSSLCertPath);
                    expect(server.options.sslkey).to.equal(absoluteSSLKeyPath);
                    return expect(server.start()).to.eventually.be.fulfilled;
                });
            });
            context("File Write Mode", function () {
                it("should start correctly with 'overwrite'", function () {
                    return expect(server_1.default({
                        pactFileWriteMode: "overwrite",
                    }).start()).to.eventually.be.fulfilled;
                });
                it("should start correctly with 'merge'", function () {
                    return expect(server_1.default({
                        pactFileWriteMode: "merge",
                    }).start()).to.eventually.be.fulfilled;
                });
                it("should start correctly with 'update'", function () {
                    return expect(server_1.default({
                        pactFileWriteMode: "update",
                    }).start()).to.eventually.be.fulfilled;
                });
            });
            context("Log Level", function () {
                it("should start correctly with 'debug'", function () {
                    return q.allSettled([
                        expect(server_1.default({
                            logLevel: "debug",
                        }).start()).to.eventually.be.fulfilled,
                        expect(server_1.default({
                            logLevel: "DEBUG",
                        }).start()).to.eventually.be.fulfilled,
                    ]);
                });
                it("should start correctly with 'info'", function () {
                    return q.allSettled([
                        expect(server_1.default({
                            logLevel: "info",
                        }).start()).to.eventually.be.fulfilled,
                        expect(server_1.default({
                            logLevel: "INFO",
                        }).start()).to.eventually.be.fulfilled,
                    ]);
                });
                it("should start correctly with 'warn'", function () {
                    return q.allSettled([
                        expect(server_1.default({
                            logLevel: "warn",
                        }).start()).to.eventually.be.fulfilled,
                        expect(server_1.default({
                            logLevel: "WARN",
                        }).start()).to.eventually.be.fulfilled,
                    ]);
                });
                it("should start correctly with 'error'", function () {
                    return q.allSettled([
                        expect(server_1.default({
                            logLevel: "error",
                        }).start()).to.eventually.be.fulfilled,
                        expect(server_1.default({
                            logLevel: "ERROR",
                        }).start()).to.eventually.be.fulfilled,
                    ]);
                });
            });
        });
        it("should dispatch event when starting", function (done) {
            server = server_1.default();
            server.once("start", function () { return done(); });
            server.start();
        });
        it("should change running state to true", function () {
            server = server_1.default();
            return server.start()
                .then(function () { return expect(server["__running"]).to.be.true; });
        });
    });
    describe("Stop server", function () {
        context("when already started", function () {
            it("should stop running", function () {
                server = server_1.default();
                return server.start().then(function () { return server.stop(); });
            });
            it("should dispatch event when stopping", function (done) {
                server = server_1.default();
                server.once("stop", function () { return done(); });
                server.start().then(function () { return server.stop(); });
            });
            it("should change running state to false", function () {
                server = server_1.default();
                return server.start()
                    .then(function () { return server.stop(); })
                    .then(function () { return expect(server["__running"]).to.be.false; });
            });
        });
    });
    describe("Delete server", function () {
        context("when already running", function () {
            it("should stop & delete server", function () {
                server = server_1.default();
                return server.start()
                    .then(function () { return server.delete(); });
            });
            it("should dispatch event when deleting", function (done) {
                server = server_1.default();
                server.once("delete", function () { return done(); });
                server.start().then(function () { return server.delete(); });
            });
            it("should change running state to false", function () {
                server = server_1.default();
                return server.start()
                    .then(function () { return server.delete(); })
                    .then(function () { return expect(server["__running"]).to.be.false; });
            });
        });
    });
});
//# sourceMappingURL=server.spec.js.map