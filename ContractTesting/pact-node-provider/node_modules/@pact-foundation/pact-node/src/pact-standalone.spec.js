"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var chai = require("chai");
var install_1 = require("../standalone/install");
var pact_util_1 = require("./pact-util");
var pact_standalone_1 = require("./pact-standalone");
var expect = chai.expect;
var basePath = pact_util_1.default.cwd;
describe("Pact Standalone", function () {
    this.timeout(600000);
    var pact;
    after(function () { return install_1.default(); });
    it("should return an object with cwd, file and fullPath properties that is platform specific", function () {
        pact = pact_standalone_1.standalone();
        expect(pact).to.be.an("object");
        expect(pact.cwd).to.be.ok;
        expect(pact.brokerPath).to.contain("pact-broker");
        expect(pact.brokerFullPath).to.contain("pact-broker");
        expect(pact.mockServicePath).to.contain("pact-mock-service");
        expect(pact.mockServiceFullPath).to.contain("pact-mock-service");
        expect(pact.stubPath).to.contain("pact-stub-service");
        expect(pact.stubFullPath).to.contain("pact-stub-service");
        expect(pact.verifierPath).to.contain("pact-provider-verifier");
        expect(pact.verifierFullPath).to.contain("pact-provider-verifier");
    });
    it("should return the base directory of the project with 'cwd' (where the package.json file is)", function () {
        expect(fs.existsSync(path.resolve(pact.cwd, "package.json"))).to.be.true;
    });
    describe("Check if OS specific files are there", function () {
        describe("OSX", function () {
            before(function () { return install_1.default("darwin"); });
            beforeEach(function () { return pact = pact_standalone_1.standalone("darwin"); });
            it("broker relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.brokerPath))).to.be.true;
            });
            it("broker full path", function () {
                expect(fs.existsSync(pact.brokerFullPath)).to.be.true;
            });
            it("mock service relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.mockServicePath))).to.be.true;
            });
            it("mock service full path", function () {
                expect(fs.existsSync(pact.mockServiceFullPath)).to.be.true;
            });
            it("stub relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.stubPath))).to.be.true;
            });
            it("stub full path", function () {
                expect(fs.existsSync(pact.stubFullPath)).to.be.true;
            });
            it("provider verifier relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.verifierPath))).to.be.true;
            });
            it("provider verifier full path", function () {
                expect(fs.existsSync(pact.verifierFullPath)).to.be.true;
            });
        });
        describe("Linux ia32", function () {
            before(function () { return install_1.default("linux", "ia32"); });
            beforeEach(function () { return pact = pact_standalone_1.standalone("linux", "ia32"); });
            it("broker relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.brokerPath))).to.be.true;
            });
            it("broker full path", function () {
                expect(fs.existsSync(pact.brokerFullPath)).to.be.true;
            });
            it("mock service relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.mockServicePath))).to.be.true;
            });
            it("mock service full path", function () {
                expect(fs.existsSync(pact.mockServiceFullPath)).to.be.true;
            });
            it("stub relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.stubPath))).to.be.true;
            });
            it("stub full path", function () {
                expect(fs.existsSync(pact.stubFullPath)).to.be.true;
            });
            it("provider verifier relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.verifierPath))).to.be.true;
            });
            it("provider verifier full path", function () {
                expect(fs.existsSync(pact.verifierFullPath)).to.be.true;
            });
        });
        describe("Linux X64", function () {
            before(function () { return install_1.default("linux", "x64"); });
            beforeEach(function () { return pact = pact_standalone_1.standalone("linux", "x64"); });
            it("broker relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.brokerPath))).to.be.true;
            });
            it("broker full path", function () {
                expect(fs.existsSync(pact.brokerFullPath)).to.be.true;
            });
            it("mock service relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.mockServicePath))).to.be.true;
            });
            it("mock service full path", function () {
                expect(fs.existsSync(pact.mockServiceFullPath)).to.be.true;
            });
            it("stub relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.stubPath))).to.be.true;
            });
            it("stub full path", function () {
                expect(fs.existsSync(pact.stubFullPath)).to.be.true;
            });
            it("provider verifier relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.verifierPath))).to.be.true;
            });
            it("provider verifier full path", function () {
                expect(fs.existsSync(pact.verifierFullPath)).to.be.true;
            });
        });
        describe("Windows", function () {
            before(function () { return install_1.default("win32"); });
            beforeEach(function () { return pact = pact_standalone_1.standalone("win32"); });
            it("should add '.bat' to the end of the binary names", function () {
                expect(pact.brokerPath).to.contain("pact-broker.bat");
                expect(pact.brokerFullPath).to.contain("pact-broker.bat");
                expect(pact.mockServicePath).to.contain("pact-mock-service.bat");
                expect(pact.mockServiceFullPath).to.contain("pact-mock-service.bat");
                expect(pact.stubPath).to.contain("pact-stub-service.bat");
                expect(pact.stubFullPath).to.contain("pact-stub-service.bat");
                expect(pact.verifierPath).to.contain("pact-provider-verifier.bat");
                expect(pact.verifierFullPath).to.contain("pact-provider-verifier.bat");
            });
            it("broker relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.brokerPath))).to.be.true;
            });
            it("broker full path", function () {
                expect(fs.existsSync(pact.brokerFullPath)).to.be.true;
            });
            it("mock service relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.mockServicePath))).to.be.true;
            });
            it("mock service full path", function () {
                expect(fs.existsSync(pact.mockServiceFullPath)).to.be.true;
            });
            it("stub relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.stubPath))).to.be.true;
            });
            it("stub full path", function () {
                expect(fs.existsSync(pact.stubFullPath)).to.be.true;
            });
            it("provider verifier relative path", function () {
                expect(fs.existsSync(path.resolve(basePath, pact.verifierPath))).to.be.true;
            });
            it("provider verifier full path", function () {
                expect(fs.existsSync(pact.verifierFullPath)).to.be.true;
            });
        });
    });
});
//# sourceMappingURL=pact-standalone.spec.js.map