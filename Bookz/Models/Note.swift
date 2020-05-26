//
//  Note.swift
//  Bookz
//
//  Created by Andrei Mesina on 10/05/2020.
//  Copyright © 2020 Andrei Mesina. All rights reserved.
//

import Foundation

struct Note : Codable {
    let id: Int
    let bookId: Int
    let note: String
    let page: Int
}
