//
//  NoteDetailViewController.swift
//  UIKitWithStoryboard
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    var note: Note?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!

    override func viewDidLoad() {
        nameLabel.text = note?.name
        contentsTextView.text = note?.contents
    }
}
