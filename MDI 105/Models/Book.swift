//
//  Book.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import SwiftUI

struct Book: Identifiable {
    let id = UUID() // Universally Unique Identifier, provides unique value, it tells things apart in the project
    var title: String
    var author: String
    var image: String
    var description: String
    var rating: Int // Double VS Int
    var review: String
    var status: BookStatus
    
}
