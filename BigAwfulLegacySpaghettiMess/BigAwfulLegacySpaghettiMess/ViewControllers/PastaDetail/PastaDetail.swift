//
//  PastaDetail.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation
import UIKit

class PastaDetail: UITableViewController, PastaDetailPresenterInput {
    var pastName: String = Constants.ViewControllerConstants.macaroni
    var presenter: PastaDetailPresenterOutput!

    override func viewDidLoad() {
        presenter = PastaDetailPresenter(view: self)
        presenter.getPasta(pastaName: pastName) { [self] pasta in
            (tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! PastaDetailTitleCell).titleLabel.text = pasta.name
            (tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! PastaDetailImageCell).customImageView.image = pasta.image.toImage
        }
    }
}

class PastaDetailTitleCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
}

class PastaDetailImageCell: UITableViewCell {
    @IBOutlet var customImageView: UIImageView!
}
