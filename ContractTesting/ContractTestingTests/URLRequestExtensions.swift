//
//  URLRequestExtensions.swift
//  HTTPStubbingTests
//
//  Created by thompsty on 1/20/21.
//

import Foundation
extension URLRequest {
    enum HTTPMethod {
        case get
        case put
        case post
        case patch
        case delete
    }

    init(_ method: HTTPMethod, urlString: String) {
        let url = URL(string: urlString)
        self.init(url: url!)
        httpMethod = "\(method)".uppercased()
    }

    func bodySteamAsData() -> Data? {
        guard let bodyStream = self.httpBodyStream else { return nil }

        bodyStream.open()

        // Will read 16 chars per iteration. Can use bigger buffer if needed
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        var data = Data()

        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }

        buffer.deallocate()
        bodyStream.close()
        return data
    }
}
