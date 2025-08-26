//
//  BookUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/26/25.
//
// Simple test function
func testBookUIDisplayProperties() {
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
    
    // Test UI display properties
    assert(testBook.title == "The Great Gatsby")
    assert(testBook.author == "F. Scott Fitzgerald")
    assert(testBook.rating == 4)
    assert(testBook.isFavorite == true)
    assert(testBook.image == "gatsby-cover.jpg")
    
    print("✅ All book UI properties test passed!")
}
