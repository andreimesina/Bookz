//
//  NotesManager.swift
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
 the data layer corresponding to the [Note] model.
*/
class NotesManager {
    
    let firestore = Firestore.firestore()
    
    /**
     Fetches an [Array] containing all the [Note]s data.
     */
    func getAllNotes(completion: @escaping ([Note]?) -> Void) {
        var notes = [Note]()
        
        firestore.collection("notes")
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Failed to fetch notes: \(error)")
                    completion(nil)
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let result = Result {
                            try document.data(as: Note.self)
                        }
                        
                        switch result {
                            case .success(let note):
                                if let note = note {
                                    notes.append(note)
                                } else {
                                    print("Note does not exist.")
                                }
                            case .failure(let error):
                                print("Error decoding note: \(error)")
                        }
                    }
                    completion(notes)
                }
            }
    }
    
    func addNote(note: Note) {
        do {
            try firestore.collection("notes").addDocument(from: note) { err in
            }
        } catch let error {
            print("Error writing book to Firestore: \(error)")
        }
    }
    
}
