//
//  BooksController.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit

protocol BooksControllerDelegate: class {
    func displayPdf(pdfUrl: URL, book: Book)
}

class BooksController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: BooksControllerDelegate?
    
    var booksManager = BooksManager()
    var genresManager = GenresManager()
    
    var books = [Book]();
    var genres = [Genre]();
    var usedGenres = [Int]();
    
    private var isTableInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchInitialData()
        
        books.forEach { book in
            booksManager.getBookPdfLocalURL(fileName: book.fileName) { url in
                if let url = url {
                    print("Successfully fetched book! Local URL \(url)")
                } else {
                    print("Failed to fetch the book! \(book.fileName)")
                }
            }
        }
    }
    
    private func fetchInitialData() {
        fetchBooks {
            self.fetchGenres {
                if (self.isTableInitialized == false) {
                    self.setupTableView()
                    self.isTableInitialized = true
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchBooks(completion: @escaping () -> Void = {}) {
        booksManager.getAllBooks { fetchedBooks in
            if let fetchedBooks = fetchedBooks {
                self.books = fetchedBooks
            } else {
                return
            }
            
            self.books.forEach { book in
                self.usedGenres.append(book.genreId)
                print("Book: \(book)")
            }
            
            completion()
        }
    }
    
    private func fetchGenres(completion: @escaping () -> Void = {}) {
        genresManager.getAllGenres { fetchedGenres in
            if let fetchedGenres = fetchedGenres {
                self.genres = fetchedGenres
            } else {
                return
            }
            
            self.genres.forEach { genre in
                print("Genre: \(genre)")
            }
            
            completion()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func onAddButtonClick(_: UIButton) {
        let addBookController = storyboard?.instantiateViewController(identifier: "AddBookViewController") as! AddBookController;
        addBookController.delegate = self
        
        present(addBookController, animated: true)
    }
}

extension BooksController: AddBookControllerDelegate {
    func setAddedBookSuccess(isSuccessful: Bool) {
        if (isSuccessful) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                self.fetchBooks() {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension BooksController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        
        let bookReaderController = storyboard?.instantiateViewController(identifier: "BookReaderViewController") as! BookReaderController;
        delegate = bookReaderController
        booksManager.getBookPdfLocalURL(fileName: book.fileName) { url in
            guard let url = url else {
                return
            }
            self.delegate?.displayPdf(pdfUrl: url, book: book)
        }
        
        present(bookReaderController, animated: true)
    }
}

extension BooksController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return genres.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books
            .filter { book in
                book.genreId == genres[section].id
            }
            .count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if usedGenres.contains(section) {
            return genres[section].name.uppercased()
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as? BookTableViewCell else {
            fatalError("Failed to reuse cell")
        }
        
        let book = books[indexPath.row]
        cell.titleLabel.text = book.title
        cell.authorLabel.text = book.author
        cell.pagesLabel.text = "\(book.currentPage)/\(book.pages)"
        
        return cell
    }
}
