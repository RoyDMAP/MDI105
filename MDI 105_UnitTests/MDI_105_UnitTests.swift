//
//  MDI_105_UnitTests.swift
//  MDI 105_UnitTests
//
//  Created by Roy Dimapilis on 8/25/25.
//

import Testing
@testable import MDI_105

@Suite("Initial Tests for MDI 105")
struct MDI_105_UnitTests {
    
    @Test("BookModelInit")
    func bookModelInit() {
        // First, test if we can create a Book with minimal parameters
        let book1 = Book(
            title: "Test Title",
            author: "Test Author"
        )
        
        // Test basic properties
        #expect(book1.title == "Test Title")
        #expect(book1.author == "Test Author")
    }
}
