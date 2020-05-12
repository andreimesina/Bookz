//
//  BooksController.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit

class BooksController: UIViewController {
    
    let booksManager = BooksManager()
    let genresManager = GenresManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var books = Array<Book>();
        var genres = Array<Genre>();
        
        booksManager.getAllBooks { fetchedBooks in
            guard fetchedBooks != nil else {
                return
            }
            
            books = fetchedBooks!
            books.forEach { book in
                print("Book: \(book)")
            }
        }
        
        genresManager.getAllGenres { fetchedGenres in
            if let fetchedGenres = fetchedGenres {
                genres = fetchedGenres
            } else {
                return
            }
            
            genres.forEach { genre in
                print("Genre: \(genre)")
            }
        }
        
        books.forEach { book in
            booksManager.getBookPDFLocalURL(fileName: book.fileName) { url in
                if let url = url {
                    print("Successfully fetched book! Local URL \(url)")
                } else {
                    print("Failed to fetch the book! \(book.fileName)")
                }
            }
        }
        
        
    }
    
}
