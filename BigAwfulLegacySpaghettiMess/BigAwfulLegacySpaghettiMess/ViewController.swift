//
//  ViewController.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var indicator: UIView!
    @IBOutlet weak var spaghettiLabel: UILabel!
    @IBOutlet weak var spaghetti: UIImageView!
    @IBOutlet weak var Carbinara: UILabel!
    @IBOutlet weak var carbonara: UIImageView!
    @IBOutlet weak var macaroni: UIButton!
    @IBOutlet weak var fettucini: UIButton!
    @IBOutlet weak var Alfrado: UIImageView!
    @IBOutlet weak var penneLabel: UILabel!
    @IBOutlet weak var penne: UIImageView!


    @IBOutlet var spaghettiTapped: UITapGestureRecognizer!
    @IBAction func spaghettiTapped(_ sender: Any) {
//        performSegue(withIdentifier: "PastaDetail", sender: <#T##Any?#>)
        performSegue(withIdentifier: Constants.ViewControllerConstants.segueToDetailPage, sender: Constants.ViewControllerConstants.spaghetti)
    }
    //    @IBSegueAction func PastaDetail(_ coder: NSCoder) -> UITableViewController? {
//        return <#UITableViewController(coder: coder)#>
//    }
    override func viewDidLoad() {
        NetworkManager.getPastas {
            self.self.loadPasts()
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        loadPasts()
    }

    public func loadPasts() {
        indicator.isHidden = true
        let spaghetti = NetworkManager.pastaCache.first { (pasta) -> Bool in
            pasta.name == Constants.ViewControllerConstants.spaghetti
        }
        spaghettiLabel.text = spaghetti?.name
//        spaghetti?.image = spaghetti?.image
        self.spaghetti.image = spaghetti?.image.toImage

        let carbonara = NetworkManager.pastaCache.filter { (pasta) -> Bool in
            pasta.name == Constants.ViewControllerConstants.cabonari
        }.first
        self.Carbinara.text = carbonara?.name
        self.carbonara.image = carbonara?.image.toImage

//        carbonara = NetworkManager.pastaCache.filter { (pasta) -> Bool in
//            pasta.name == "macaroni"
//        }.first
//        self.Carbinara.text = carbonara?.name
//        self.macaroni.image = carbonara?.image.toImage
        
    }
}
