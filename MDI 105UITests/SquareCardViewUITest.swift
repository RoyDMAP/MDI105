//
//  SquareCardViewUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/30/25.
//

import XCTest

final class FavoritesFlowTests: XCTestCase {
    
    @MainActor
    func testTogglingFavorite() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tabBarButton = app.tabBars.buttons["My Books"]
        XCTAssert(tabBarButton.exists)
        
        let cellCount = app.tables.cells.count
        XCTAssert(cellCount > 0)
        
        // Tap the first book
        let firstBook = app.tables.cells.element(boundBy: 0)
        firstBook.tap()
        
        // look for and tap the favorite button
        let favoriteButton = app.buttons.containing(.image, identifier: "heart").element
        if favoriteButton.exists {
            favoriteButton.tap()
        }
        
        //Navigate back to the book list
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        //Navigate to the favorites tab
        let favoritesTab = app.tabBars.buttons["Favorites"]
        favoritesTab.tap()
        
        //Verify the book appears in favorites also based on grid structure
        let favoriteBooks = app.scrollViews.otherElements.buttons
        XCTAssert(favoriteBooks.count > 0, "Should have at least one favorite book")
        
        XCTAssertTrue(app.collectionViews.staticTexts.count > 0, "Collection view should contain book text elements")
        
        
    }
}
