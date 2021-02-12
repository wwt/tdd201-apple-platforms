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

    @IBOutlet weak var notesTableView:UITableView!

    override func viewDidLoad() {
        switch notesService?.getNotes() {
            case .success(let notes): self.notes = notes
            case .failure, .none: notes = []
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dst = segue.destination as? NoteDetailViewController,
              let note = sender as? Note else {
            return
        }
        dst.note = note
    }

    @IBAction func addNote() {
        var note = Note(name: "note\(notes.count+1)", contents: "")
        let notesWithSameName = notes.filter { $0.name == note.name }
        if notesWithSameName.count > 0 {
            note = Note(name: "note\(notes.count+1) (\(notesWithSameName.count))", contents: "")
        }
        notes.append(note)
        try? notesService?.save(note: note)
        notesTableView.reloadData()
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

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "SegueToNoteDetailsViewController", sender: note)
    }
}
