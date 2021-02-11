//
//  NotesListViewController.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import UIKit

class NotesListViewController: UIViewController {
    @DependencyInjected var notesService: NotesService?
    var notes: [Note] = []

    override func viewDidLoad() {
        switch notesService?.getNotes() {
            case .success(let notes): self.notes = notes
            case .failure, .none: notes = []
        }
    }
}

extension NotesListViewController: UITableViewDataSource {
    enum Identifiers {
        static let noteCell = "NotesTableViewReuseIdentifier"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.noteCell, for: indexPath)
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.name
        return cell
    }

}
