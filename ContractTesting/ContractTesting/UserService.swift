//
//  UserService.swift
//  ContractTesting
//
//  Created by thompsty on 1/21/21.
//

import Foundation

struct UserService {
    enum UserServiceError: Error {
        case apiBorked
    }

    var baseURLString = "https://api.fake.com"
    func getUser(callback: @escaping (Result<SomeModel, Error>) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "\(baseURLString)/users/1")!) { (data, _, err) in
            guard let data = data,
                  let model = try? JSONDecoder().decode(SomeModel.self, from: data) else {
                callback(.failure(err ?? UserServiceError.apiBorked))
                return
            }
            callback(.success(model))
        }.resume()
    }
}
