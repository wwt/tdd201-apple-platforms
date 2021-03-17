//
//  PastaDetail.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation
import UIKit

class PastaDetail: UITableViewController {
    var pastName: String = Constants.ViewControllerConstants.macaroni

    override func viewDidLoad() {
        NetworkManager.getPasta(pastaName: pastName) { pasta in
            DispatchQueue.main.async { [self] in
                (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PastaDetailTitleCell).titleLabel.text = pasta.name
            }
        }
    }
}

class PastaDetailTitleCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
}
