//
//  UserService.swift
//  ContractTesting
//
//  Created by thompsty on 2/16/21.
//

import Foundation

struct UserService {
    var baseURL: String = "https://fake.api.com/"

    func getUser(id: Int, callback: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users/\(id)") else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, res, _ in
            if let res = res as? HTTPURLResponse,
               res.statusCode == 404 {
                callback(.failure(UserServiceError.notFound))
            }
            guard let data = data,
                  let user = try? JSONDecoder().decode(User.self, from: data) else { return }
            callback(.success(user))
        }.resume()
    }
}

extension UserService {
    enum UserServiceError: Error {
        case notFound
    }
}
