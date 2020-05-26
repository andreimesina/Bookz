//
//  GenresManager.swift
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
 the data layer corresponding to the [Genre] model.
*/
class GenresManager {
    
    let firestore = Firestore.firestore()
    
    /**
     Fetches an [Array] containing all the [Genre]s data.
     */
    func getAllGenres(completion: @escaping ([Genre]?) -> Void) {
        var genres = [Genre]()
        
        firestore.collection("genres")
            .getDocuments() { querySnapshot, error in
                if let error = error {
                    print("Failed to fetch genres: \(error)")
                    completion(nil)
                } else if let querySnapshot = querySnapshot {
                    for document in querySnapshot.documents {
                        let result = Result {
                            try document.data(as: Genre.self)
                        }
                        
                        switch result {
                            case .success(let genre):
                                if let genre = genre {
                                    genres.append(genre)
                                } else {
                                    print("Genre does not exist.")
                                }
                            case .failure(let error):
                                print("Error decoding genre: \(error)")
                        }
                    }
                    completion(genres)
                }
            }
    }
    
}
