//
//  ViewController.swift
//  CombineWithREST
//
//  Created by thompsty on 1/19/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @DependencyInjected var identityService: IdentityServiceProtocol?

    var ongoingCalls = Set<AnyCancellable>()

    @IBOutlet weak var nameLabel: UILabel!

    func fetchProfile() {
        identityService?.fetchProfile.sink(receiveValue: { [weak self] (result) in
            switch result {
                case .success(let profile):
                    self?.nameLabel?.text = [profile.firstName, profile.lastName].compactMap { $0 }.joined(separator: " ")
                case .failure(let err):
                    let alertVC = UIAlertController(title: "Something went wrong", message: err.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Ok", style: .default))
                    self?.present(alertVC, animated: true)
            }
        })
        .store(in: &ongoingCalls)
    }
}
