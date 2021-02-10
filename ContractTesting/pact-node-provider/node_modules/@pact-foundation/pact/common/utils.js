"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// Convert a q promise to regular Promise
function qToPromise(promise) {
    return new Promise(function (resolve, reject) {
        promise
            .then(function (value) { return resolve(value); }, function (error) { return reject(error); });
    });
}
exports.qToPromise = qToPromise;
//# sourceMappingURL=utils.js.map