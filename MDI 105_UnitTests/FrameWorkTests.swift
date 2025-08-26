//
//  FrameWorkTests.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/26/25.
//

//import XCTest
//import SwiftUI
//@testable import MDI_105

//class BookAppUITests: XCTestCase {
//
//    var app: XCUIApplication!
//
//    override func setUpWithError() throws {
//        continueAfterFailure = false
//        app = XCUIApplication()
//        app.launch()
//    }
//
//    override func tearDownWithError() throws {
//        app = nil
//    }
//
//    // Navigation Tests
//    func testTabNavigation() throws {
//        // Test My Books tab
//        let myBooksTab = app.tabBars.buttons["My Books"]
//        XCTAssertTrue(myBooksTab.exists)
//        myBooksTab.tap()
//
//        // Test Favorites tab
//        let favoritesTab = app.tabBars.buttons["Favorites"]
//        XCTAssertTrue(favoritesTab.exists)
//        favoritesTab.tap()
//
//        // Test Settings tab
//        let settingsTab = app.tabBars.buttons["Settings"]
//        XCTAssertTrue(settingsTab.exists)
//        settingsTab.tap()
//
//        // Navigate back to My Books
//        myBooksTab.tap()
//    }
//}
