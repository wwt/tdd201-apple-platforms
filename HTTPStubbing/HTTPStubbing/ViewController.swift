//
//  ViewController.swift
//  HTTPStubbing
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    var model: SomeModel?

    func makeNetworkRequest() {
        URLSession.shared.dataTask(with: URL(string: "https://api.fake.com/users/me")!) { (data, _, _) in
            guard let data = data else { return }
            self.model = try? JSONDecoder().decode(SomeModel.self, from: data)
        }.resume()
    }

}
