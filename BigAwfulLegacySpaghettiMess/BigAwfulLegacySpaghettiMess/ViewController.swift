//
//  ViewController.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        NetworkManager.getPastas()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
