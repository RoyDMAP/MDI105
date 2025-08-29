//
//  BookUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/26/25.
//
// Simple test function
import Testing
import SnapshotTesting

// Define the Genre enum
enum Genre {
    case fiction
    case nonFiction
    case mystery
    case romance
    case sciFi
    case fantasy
    case biography
    case history
}

// Define the Book struct
struct Book {
    let title: String
    let author: String
    let image: String
    let description: String
    let rating: Int
    let genre: Genre
    let isFavorite: Bool
    
    init(title: String, author: String, image: String, description: String, rating: Int, genre: Genre, isFavorite: Bool) {
        self.title = title
        self.author = author
        self.image = image
        self.description = description
        self.rating = rating
        self.genre = genre
        self.isFavorite = isFavorite
    }
}

@Test func testBookUIProperties() {
    // Create a test book with UI-relevant properties
    let testBook = Book(
        title: "The Great Gatsby",
        author: "F. Scott Fitzgerald",
        image: "gatsby-cover.jpg",
        description: "A classic American novel",
        rating: 4,
        genre: .fiction,
        isFavorite: true
    )
    
    // Test UI display properties using Swift Testing expectations
    #expect(testBook.title == "The Great Gatsby")
    #expect(testBook.author == "F. Scott Fitzgerald")
    #expect(testBook.rating == 4)
    #expect(testBook.isFavorite == true)
    #expect(testBook.image == "gatsby-cover.jpg")
    
    print("✅ All book UI properties test passed!")
}
