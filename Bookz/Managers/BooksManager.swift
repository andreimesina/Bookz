//
//  BooksManager.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

/**
 This component is responsible for handling
 the data layer corresponding to the [Book] model and its files.
 */
class BooksManager {
    
    let firestore = Firestore.firestore()
    
    let storage = Storage.storage()
    lazy var storageReference = storage.reference()
    
    let baseLocalURL = DirectoryUtils.getAppSupportDirectoryURL()
    let booksDirectoryPrefix = "books/pdf/"
    let coverImagesDirectoryPrefix = "books/cover/"
    
    /**
     Fetches an [Array] containing all the [Book]s data.
     */
    func getAllBooks(completion: @escaping ([Book]?) -> Void) {
        var books = [Book]()
        
        firestore.collection("books")
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Failed to fetch books: \(error)")
                    completion(nil)
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let result = Result {
                            try document.data(as: Book.self)
                        }
                        
                        switch result {
                            case .success(let book):
                                if let book = book {
                                    books.append(book)
                                } else {
                                    print("Book does not exist.")
                                }
                            case .failure(let error):
                                print("Error decoding book: \(error)")
                        }
                    }
                    completion(books)
                }
            }
    }
    
    /**
     Downloads the book and returns the local [URL] of the PDF file,
     or directly returns the [URL] if the book has been already downloaded before.
     */
    func getBookPDFLocalURL(fileName: String, completion: @escaping (URL?) -> Void) {
        // Local path of the file
        guard let localURL = baseLocalURL?
            .appendingPathComponent(booksDirectoryPrefix)
            .appendingPathComponent(fileName) else {
                completion(nil)
                return
            }
        
        // If book was already downloaded, just return its location
        if DirectoryUtils.isFileExisting(url: localURL) {
            completion(localURL)
            return
        }
        
        let bookReference = storageReference.child(booksDirectoryPrefix + fileName)
        bookReference.write(toFile: localURL) { (url, error) in
            if let error = error {
                print("Could not fetch " + fileName + " : \n" + error.localizedDescription)
                completion(nil)
            }
            
            if let url = url {
                print("Download Task success: \(url)")
                completion(url)
            }
        }
    }
    
    /**
     Downloads the book cover image and returns the local [URL] of the file,
     or directly returns the [URL] if the cover image has been already downloaded.
     */
    func getBookCoverImageLocalURL(imageFileName: String, completion: @escaping (URL?) -> Void) {
        // Local path of the file
        guard let localURL = baseLocalURL?
            .appendingPathComponent(coverImagesDirectoryPrefix)
            .appendingPathComponent(imageFileName) else {
                completion(nil)
                return
            }
        
        // If book was already downloaded, just return its location
        if DirectoryUtils.isFileExisting(url: localURL) {
            completion(localURL)
            return
        }
        
        let coverReference = storageReference.child(booksDirectoryPrefix + imageFileName)
        coverReference.write(toFile: localURL) { (url, error) in
            if let error = error {
                print("Could not fetch " + imageFileName + " : \n" + error.localizedDescription)
                completion(nil)
            }
            
            if let url = url {
                print("Download Task success: \(url)")
                completion(url)
            }
        }
    }
}
