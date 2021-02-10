"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// Polyfill Object.assign since it's missing in Popsicle
require("es6-object-assign").polyfill();
var Popsicle = require("popsicle/dist/common");
var HTTPMethod;
(function (HTTPMethod) {
    HTTPMethod["GET"] = "GET";
    HTTPMethod["POST"] = "POST";
    HTTPMethod["PUT"] = "PUT";
    HTTPMethod["PATCH"] = "PATCH";
    HTTPMethod["DELETE"] = "DELETE";
    HTTPMethod["HEAD"] = "HEAD";
    HTTPMethod["OPTIONS"] = "OPTIONS";
})(HTTPMethod = exports.HTTPMethod || (exports.HTTPMethod = {}));
var Request = /** @class */ (function () {
    function Request() {
        this.transport = Popsicle.createTransport({
            rejectUnauthorized: false,
            type: "text",
        });
    }
    Request.prototype.send = function (method, url, body) {
        var opts = {
            body: body,
            headers: {
                "Content-Type": "application/json",
                "X-Pact-Mock-Service": "true",
            },
            method: method,
            timeout: 10000,
            transport: this.transport,
            url: url,
        };
        return Popsicle.request(opts)
            .then(function (res) {
            if (res.status >= 200 && res.status < 400) {
                return res.body;
            }
            else {
                return Promise.reject(res.body);
            }
        });
    };
    return Request;
}());
exports.Request = Request;
//# sourceMappingURL=request.js.map