//
//  TappableView.swift
//  BigAwfulLegacySpaghettiMess
//
//  Created by thompsty on 3/17/21.
//

import Foundation
import UIKit

class TappableView: UIView {
    private var recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didGetTapped))
    // should be weak, maybe next release????
    var tapDelegate: TappableViewDelegate?
//    var _didGetTapped: ()->() = { }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addGestureRecognizer()
    }

    private func addGestureRecognizer() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didGetTapped)))
    }

    @objc func didGetTapped() {
        tapDelegate?.didGetTapped()
    }
}

protocol TappableViewDelegate: class {
    func didGetTapped() -> Swift.Void
}
