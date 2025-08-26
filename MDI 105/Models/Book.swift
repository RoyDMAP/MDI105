//
//  Book.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import Foundation
import SwiftUI

// MARK: - Book Model
struct Book: Identifiable, Codable, Hashable, Equatable {
    let id: UUID
    var title: String
    var author: String
    var image: String
    var description: String
    var rating: Int
    var review: String
    var status: BookStatus
    var genre: Genre
    var isFavorite: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        author: String,
        image: String,
        description: String,
        rating: Int = 0,
        review: String = "",
        status: BookStatus = .notStarted,
        genre: Genre,
        isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.author = author
        self.image = image
        self.description = description
        self.rating = rating
        self.review = review
        self.status = status
        self.genre = genre
        self.isFavorite = isFavorite
    }
}
