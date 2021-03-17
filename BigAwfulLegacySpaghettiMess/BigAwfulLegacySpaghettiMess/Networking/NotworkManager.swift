//
//  NotworkManager.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

//THESE PROPERTIES OF A PASTA
//
//var name: String!
//var image: Data!
//var length: Measurement<UnitLength>!

import Foundation
typealias JSON = [AnyHashable: Any]
class NetworkManager: NSObject {
    static var makingRequest = false
    static var pastaCache = [Pasta]()
    static func getPastas(_ callback: (()->())? = nil) {
        makingRequest = true
        var inSameFunction = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(currentEnvironment == Envirnment.demo ? 5 : 0)) {

            if (makingRequest && !inSameFunction) {
                DispatchQueue.main.sync {
                    while (makingRequest) {} // Wait for request, thanks stack overflow!
                }
            } else {
                inSameFunction = false
                if (currentEnvironment == .demo || currentEnvironment == .stage && currentEnvironment != .prod) {
                    #if DEBUG
                    Hippolyte.shared.add(stubbedRequest: StubRequest.Builder()
                                            .stubRequest(withMethod: .get, url: URL(string: "http://www.pastaApi.com/pastas")!)
                                            .addResponse(StubResponse.Builder()
                                                            .stubResponse(withStatusCode: 200)
                                                            .addHeader(withKey: "Content-Type", value: "application/json")
                                                            .addBody(try! JSONSerialization.data(withJSONObject: JSON.init(dictionaryLiteral:
                                                                                                                            ("result", [[
                                                                                                                                "name" : Constants.Network.spaghetti,
                                                                                                                                "image" : sphgettiImage,
                                                                                                                                "length" : 10,
                                                                                                                            ],
                                                                                                                            [
                                                                                                                                "name" : Constants.Network.cabonari,
                                                                                                                                "image" : carbonaraImage,
                                                                                                                                "length" : 12,
                                                                                                                            ],
                                                                                                                            [
                                                                                                                                "name" : Constants.Network.macaroni,
                                                                                                                                "image" : macaroinImage,
                                                                                                                                "length" : 1,
                                                                                                                            ]])
                                                            ), options: [.prettyPrinted]))
                                                            .build())
                                            .build())
                    Hippolyte.shared.start()

                    AF.request("http://www.pastaApi.com/pastas").response { response in
                        for pasta in ConvertPastaResponse(data: response).data {
                            pastaCache.append(pasta)
                        }
                        (callback ?? {})()
                        makingRequest = false
                    }

                    #else
                    getPastasProd()
                    #endif
                } else {
                    fatalError("This should never happen")
                }
            }
        }
    }

    private static func getPastasProd() {

    }

    static func getPasta(pastaName: String, _ callback: ((Pasta)->())? = nil) {
        let nameToId = [
            Constants.Network.macaroni : "1",
            Constants.Network.spaghetti : "2",
            Constants.Network.cabonari : "3",
        ][pastaName]
        makingRequest = true
        var inSameFunction = true
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(currentEnvironment == Envirnment.demo ? 5 : 0)) {

            if (makingRequest && !inSameFunction) {
                DispatchQueue.main.sync {
                    while (makingRequest) {} // Wait for request, thanks stack overflow!
                }
            } else {
                inSameFunction = false
                if (currentEnvironment == .demo || currentEnvironment == .stage && currentEnvironment != .prod) {
                    #if DEBUG
                    Hippolyte.shared.add(stubbedRequest: StubRequest.Builder()
                                            .stubRequest(withMethod: .get, url: URL(string: "http://www.pastaApi.com/pasta/\(nameToId!)")!)
                                            .addResponse(StubResponse.Builder()
                                                            .stubResponse(withStatusCode: 200)
                                                            .addHeader(withKey: "Content-Type", value: "application/json")
                                                            .addBody(try! JSONSerialization.data(withJSONObject: JSON.init(dictionaryLiteral:
                                                                                                                            ("result", [
                                                                                                                                "name" : pastaCache.first(where: { $0.name == pastaName })!.name!,
                                                                                                                                "image" : pastaCache.first(where: { $0.name == pastaName })!.image.base64EncodedString() ,
                                                                                                                                "length" : pastaCache.first(where: { $0.name == pastaName })!.length!,
                                                                                                                            ])
                                                            ), options: [.prettyPrinted]))
                                                            .build())
                                            .build())
                    Hippolyte.shared.start()

                    AF.request("http://www.pastaApi.com/pasta/\(nameToId!)").response { response in
                        (callback ?? {_ in})(ConvertSinglePastaResponse(data: response).data)
                        makingRequest = false
                    }

                    #else
                    getPastasProd()
                    #endif
                } else {
                    fatalError("This should never happen")
                }
            }
        }
    }
}
