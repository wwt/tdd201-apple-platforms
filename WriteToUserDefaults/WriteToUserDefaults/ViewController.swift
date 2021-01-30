//
//  ViewController.swift
//  WriteToUserDefaults
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    @DependencyInjected var userDefaults:UserDefaults?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = userDefaults?.integer(forKey: "accountBalance")
    }

    func buttonPressed() {
        userDefaults?.setValue(100, forKey: Keys.UserDefaults.accountBalance)
    }
}

extension ViewController {
    enum Keys {
        enum UserDefaults {
            static let accountBalance = "accountBalance"
        }
    }
}
