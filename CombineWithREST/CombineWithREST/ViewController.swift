//
//  ViewController.swift
//  CombineWithREST
//
//  Created by thompsty on 1/19/21.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @DependencyInjected var identityService:IdentityServiceProtocol?
    
    var ongoingCalls = Set<AnyCancellable>()
    
    var fakeNameLabel: String?
    var fakeErrorLabel: String?
    
    func fetchProfile() {
        identityService?.fetchProfile.sink(receiveValue: { [weak self] (result) in
            switch result {
                case .success(let profile):
                    self?.fakeNameLabel = [profile.firstName, profile.lastName].compactMap { $0 }.joined(separator: " ")
                case .failure(let err):
                    self?.fakeErrorLabel = err.localizedDescription
            }
        })
        .store(in: &ongoingCalls)
    }
}

