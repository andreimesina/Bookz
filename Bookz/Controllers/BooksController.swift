//
//  BooksController.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class BooksController: UIViewController {
    
    let db = Firestore.firestore()
    let booksManager = BooksManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.collection("books").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        
        booksManager.getBookLocalURL(fileName: "the_art_of_war.pdf") { url in
            if let url = url {
                print("BooksController successfully fetched book! Local URL \(url)")
            } else {
                print("BooksController failed to fetch the book!")
            }
        }
        
        booksManager.getAllBooks { books in
            guard books != nil else {
                return
            }
            
            books?.forEach { book in
                print(book)
            }
        }
    }
    
}
