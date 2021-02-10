"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var chai = require("chai");
var index_1 = require("./index");
var expect = chai.expect;
describe("Index Spec", function () {
    it("Typescript import should work", function () {
        expect(index_1.default).to.be.ok;
        expect(index_1.default.createServer).to.be.ok;
        expect(index_1.default.createServer).to.be.a("function");
    });
    it("Node Require import should work", function () {
        var entrypoint = require("./index");
        expect(entrypoint).to.be.ok;
        expect(entrypoint.createServer).to.be.ok;
        expect(entrypoint.createServer).to.be.a("function");
    });
});
//# sourceMappingURL=index.spec.js.map