//
//  BookImageUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/30/25.
//

import XCTest

class BookImageDetailViewUITest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testBookImageDisplaysInDetailView() throws {
        let bookListView = app.collectionViews.firstMatch
        XCTAssertTrue(bookListView.waitForExistence(timeout: 5), "Book list should be visible")
        
        let firstBook = app.buttons.matching(identifier: "BookItemView").firstMatch
        XCTAssertTrue(firstBook.waitForExistence(timeout: 3), "First book should exist in list")
        firstBook.tap()
        
        let detailView = app.scrollViews.firstMatch
        XCTAssertTrue(detailView.waitForExistence(timeout: 3), "Detail view should load")
        
        let bookImage = app.images.matching(NSPredicate(format: "identifier CONTAINS 'book_cover_image' OR label CONTAINS 'Book cover for'")).firstMatch
        
        if bookImage.waitForExistence(timeout: 3) {
            XCTAssertTrue(bookImage.exists, "Book cover image should be displayed in detail view")
            XCTAssertTrue(bookImage.isHittable, "Book image should be visible and accessible")
            
            let imageFrame = bookImage.frame
            XCTAssertGreaterThan(imageFrame.height, 100, "Image should have reasonable height")
            XCTAssertGreaterThan(imageFrame.width, 50, "Image should have reasonable width")
            
            print("✅ Book image is displayed successfully in DetailView")
        } else {
            // No image found - check for placeholder
            let placeholderView = app.otherElements.matching(NSPredicate(format: "label CONTAINS 'No cover image available'")).firstMatch
            let bookClosedIcon = app.images["book.closed"]
            
            XCTAssertTrue(placeholderView.exists || bookClosedIcon.exists,
                         "Either book image or placeholder should be displayed in detail view")
            
            if placeholderView.exists {
                print("📷 Placeholder is displayed (no image available)")
            } else if bookClosedIcon.exists {
                print("📖 Book closed icon placeholder is displayed")
            }
        }
        
        // Does image exist
        let imageSection = app.otherElements.matching(NSPredicate(format: "identifier == 'bookCoverSection'")).firstMatch
        
        // Image related
        let hasImageContent = bookImage.exists ||
                             app.images["book.closed"].exists ||
                             app.otherElements.matching(NSPredicate(format: "label CONTAINS 'cover'")).firstMatch.exists
        
        XCTAssertTrue(hasImageContent, "Detail view should contain some form of book cover content (image or placeholder)")
        
        // Verify the detail view structure 
        let bookTitle = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'Book title:'")).firstMatch
        XCTAssertTrue(bookTitle.waitForExistence(timeout: 2), "Book title should be visible in detail view")
        
        print("✅ Book DetailView image test completed successfully")
    }
}
