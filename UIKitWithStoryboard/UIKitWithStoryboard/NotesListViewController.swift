//
//  NotesListViewController.swift
//  UIKitWithStoryboard
//
//  Created by Heather Meadow on 2/10/21.
//

import Foundation
import UIKit

class NotesListViewController: UIViewController {
    @DependencyInjected private var notesService: NotesService?
    private var notes: [Note] = []

    @IBOutlet private weak var notesTableView: UITableView!

    override func viewWillAppear(_ animated: Bool) {
        switch notesService?.getNotes() {
            case .success(let notes):
                self.notes = notes
            case .failure, .none:
                notes = []
        }
        notesTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dst = segue.destination as? NoteDetailViewController,
              let note = sender as? Note else {
            return
        }
        dst.note = note
    }

    @IBAction private func addNote() {
        var note = Note(name: "note\(notes.count+1)", contents: "")
        let notesWithSameName = notes.filter { $0.name == note.name }
        if notesWithSameName.count > 0 {
            note = Note(name: "note\(notes.count+1) (\(notesWithSameName.count))", contents: "")
        }

        do {
            try notesService?.save(note: note)
            notes.append(note)
            notesTableView.reloadData()
        } catch {
            let alert = UIAlertController(title: "Unable to add note", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }

}

extension NotesListViewController: UITableViewDataSource {
    private enum Identifiers {
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]

            let confirmationAlert = UIAlertController(title: "Confirm delete", message: "Are you sure you want to delete?", preferredStyle: .alert)
            confirmationAlert.addAction(UIAlertAction(title: "No", style: .cancel))
            confirmationAlert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
                do {
                    try self.notesService?.delete(note: note)
                    self.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } catch {
                    confirmationAlert.dismiss(animated: true) {
                        let alert = UIAlertController(title: "Unable to delete note", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        self.present(alert, animated: true)
                    }
                }
            })

            present(confirmationAlert, animated: true)
        }
    }

}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        performSegue(withIdentifier: "SegueToNoteDetailViewController", sender: note)
    }
}
