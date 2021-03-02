//
//  NoteDetailViewController.swift
//  UIKitWithStoryboard
//
//  Created by thompsty on 1/4/21.
//

import UIKit

class NoteDetailViewController: UIViewController {
    @DependencyInjected private var notesService: NotesService?
    var note: Note?
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var contentsTextView: UITextView!

    override func viewDidLoad() {
        nameLabel.text = note?.name
        contentsTextView.text = note?.contents
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let contents = contentsTextView.text,
              let name = note?.name,
              (try? notesService?.save(note: Note(name: name, contents: contents))) != nil
        else { return }

    }
}
