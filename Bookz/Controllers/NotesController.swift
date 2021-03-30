//
//  NotesController.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit

class NotesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var booksManager = BooksManager()
    lazy var notesManager = NotesManager()
    
    var books = [Book]()
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInitialData()
        
    }
    
    private func fetchInitialData() {
        fetchNotes {
            self.fetchBooks {
                self.setupTableView()
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchNotes(completion: @escaping () -> Void = {}) {
        notesManager.getAllNotes { fetchedNotes in
            guard let fetchedNotes = fetchedNotes else {
                return
            }
            
            self.notes = fetchedNotes
            completion()
        }
    }
    
    private func fetchBooks(completion: @escaping () -> Void = {}) {
        booksManager.getAllBooks { fetchedBooks in
            guard let fetchedBooks = fetchedBooks else {
                return
            }
            
            self.books = fetchedBooks
            completion()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension NotesController: UITableViewDelegate {
    
}

extension NotesController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
            fatalError("Failed to reuse cell")
        }
        
        let note = notes[indexPath.row]
        cell.titleLabel.text = books.first { book in
            book.id == note.bookId
        }?.title
        cell.noteLabel.text = note.note
        cell.pageLabel.text = "\(note.page)"
        
        return cell
    }
}
