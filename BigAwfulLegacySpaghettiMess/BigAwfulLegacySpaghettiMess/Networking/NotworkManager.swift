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

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+(currentEnvironment == Envirnment.demo ? 5 : 0)) {

            if (makingRequest) {
                DispatchQueue.main.sync {
                    while (makingRequest) {} // Wait for request, thanks stack overflow!
                }
            } else {
                makingRequest = true
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
}
