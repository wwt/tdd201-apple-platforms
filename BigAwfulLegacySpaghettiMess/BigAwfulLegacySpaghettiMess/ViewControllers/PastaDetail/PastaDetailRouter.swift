//
//  PastaDetailRouter.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation
import UIKit

class PastaDetailRouter {
    var sourceVC: UIViewController
    var dstVC: UIViewController
    init(_ sourceVC: UIViewController, dstVC: UIViewController) {
        self.sourceVC = sourceVC
        self.dstVC = dstVC
    }
}
