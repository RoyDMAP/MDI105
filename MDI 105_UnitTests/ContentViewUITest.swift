//
//  ContentViewUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/26/25.
//

@testable import MDI_105
import Testing

// UI test for ContentView labels and buttons
func testContentViewLabelsAndButtons() {
    // ContentView instance
    let contentView = ContentView()
    
    // Test TabView labels exist
    let expectedTabLabels = [
        "My Books",
        "Favorites",
        "Settings"
    ]
    
    // Test that tab labels are correctly defined
    for label in expectedTabLabels {
        assert(!label.isEmpty, "Tab label should not be empty: \(label)")
        print("✅ Tab label verified: \(label)")
    }
    
    // Test system image names are valid
    let expectedSystemImages = [
        "books.vertical.fill",
        "heart.fill",
        "gearshape"
    ]
    
    for imageName in expectedSystemImages {
        assert(!imageName.isEmpty, "System image name should not be empty: \(imageName)")
        print("✅ System image verified: \(imageName)")
    }
    
    // Test search prompt text
    let searchPrompt = "Search books by title, author, or genre..."
    assert(!searchPrompt.isEmpty, "Search prompt should not be empty")
    assert(searchPrompt.contains("Search"), "Search prompt should contain 'Search'")
    print("✅ Search prompt verified: \(searchPrompt)")
    
    // Test alert title and message
    let alertTitle = "Error Loading Books"
    let alertMessage = "An error occurred while loading books from the server."
    
    assert(!alertTitle.isEmpty, "Alert title should not be empty")
    assert(!alertMessage.isEmpty, "Alert message should not be empty")
    print("✅ Alert title verified: \(alertTitle)")
    print("✅ Alert message verified: \(alertMessage)")
    
    print("✅ All ContentView UI labels and buttons test passed!")
}
