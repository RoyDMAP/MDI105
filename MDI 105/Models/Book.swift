//
//  Book.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import Foundation

public enum BookGenre: String, CaseIterable, Codable {
    case classic = "Classic"
    case fantasy = "Fantasy"
    case terror = "Terror"
    case dystopian = "Dystopian"
    case fiction = "Fiction"
    case nonFiction = "Non-Fiction"
    case mystery = "Mystery"
    case romance = "Romance"
    case sciFi = "Sci-Fi"
    case biography = "Biography"
    case history = "History"
}

public enum BookReadingStatus: String, CaseIterable, Codable {
    case notStarted = "Not Started"
    case reading = "Reading"
    case finished = "Finished"
    case planToRead = "Plan to Read"
}

public struct Book: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var title: String
    public var author: String
    public var image: String
    public var description: String
    public var rating: Int
    public var review: String
    public var isFavorite: Bool = false
    public var status: BookReadingStatus
    public var genre: BookGenre
    
    public init(title: String, author: String, image: String, description: String, rating: Int, review: String, isFavorite: Bool = false, status: BookReadingStatus, genre: BookGenre) {
        self.title = title
        self.author = author
        self.image = image
        self.description = description
        self.rating = rating
        self.review = review
        self.isFavorite = isFavorite
        self.status = status
        self.genre = genre
    }
    
    public static func == (lhs: Book, rhs: Book) -> Bool {
        return lhs.id == rhs.id
    }
}
