//
//  Book.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation

struct Book : Codable {
    let id: Int
    let author: String
    let coverImageName: String
    let currentPage: Int
    let fileName: String
    let genreId: Int
    let pages: Int
    let title: String
    
    var localImageURL: String = ""
    var localFileURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case coverImageName
        case currentPage
        case fileName
        case genreId
        case pages
        case title
    }
}
