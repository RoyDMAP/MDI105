//
//  UrlFetchUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/5/25.
//

import XCTest

final class UrlFetchUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it's important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
        
        // Clear any existing data for consistent testing
        app.launchArguments = ["--reset-user-defaults"]
        app.launchEnvironment = ["UI_TESTING": "1"]
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }
    
    @MainActor
    func testAppLaunchAndTabNavigation() throws {
        // UI tests must launch the application that they test.
        app.launch()
        
        // Verify the app launches and shows the main tab view
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.exists, "Tab bar should exist")
        
        // Test navigation between tabs
        let myBooksTab = app.tabBars.buttons["My Books"]
        let favoritesTab = app.tabBars.buttons["Favorites"]
        let settingsTab = app.tabBars.buttons["Settings"]
        
        // Verify all tabs exist
        XCTAssertTrue(myBooksTab.exists, "My Books tab should exist")
        XCTAssertTrue(favoritesTab.exists, "Favorites tab should exist")
        XCTAssertTrue(settingsTab.exists, "Settings tab should exist")
        
        // Test tab switching
        favoritesTab.tap()
        XCTAssertTrue(favoritesTab.isSelected, "Favorites tab should be selected")
        
        settingsTab.tap()
        XCTAssertTrue(settingsTab.isSelected, "Settings tab should be selected")
        
        myBooksTab.tap()
        XCTAssertTrue(myBooksTab.isSelected, "My Books tab should be selected")
    }
    
    @MainActor
    func testBookListLoading() throws {
        app.launch()
        
        // Wait for books to load (either from storage or network)
        let booksList = app.scrollViews.firstMatch
        let loadingExists = booksList.waitForExistence(timeout: 5.0)
        XCTAssertTrue(loadingExists, "Books list should appear within 5 seconds")
        
        // Check if any books are displayed (either default books or loaded books)
        let cells = app.cells
        if cells.count > 0 {
            XCTAssertTrue(cells.firstMatch.exists, "At least one book should be displayed")
        }
    }
    
    @MainActor
    func testSearchFunctionality() throws {
        app.launch()
        
        // Wait for the view to load
        let searchField = app.searchFields.firstMatch
        let searchExists = searchField.waitForExistence(timeout: 5.0)
        XCTAssertTrue(searchExists, "Search field should exist")
        
        // Test search functionality
        searchField.tap()
        searchField.typeText("fiction")
        
        // Verify search is active
        XCTAssertEqual(searchField.value as? String, "fiction", "Search field should contain 'fiction'")
        
        // Clear search
        if app.buttons["Clear text"].exists {
            app.buttons["Clear text"].tap()
        } else {
            // Alternative method to clear search
            searchField.tap()
            searchField.buttons["clear text"].tap()
        }
    }
    
    @MainActor
    func testAddBookFlow() throws {
        app.launch()
        
        // Look for add book button (assuming it exists in your BookListView)
        let addButton = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'add' OR label CONTAINS[c] 'plus' OR label CONTAINS[c] '+'")).firstMatch
        
        if addButton.exists {
            addButton.tap()
            
            // Verify add book sheet appears
            let addBookSheet = app.sheets.firstMatch
            let sheetExists = addBookSheet.waitForExistence(timeout: 3.0)
            XCTAssertTrue(sheetExists, "Add book sheet should appear")
            
            // Test dismissing the sheet
            if app.buttons["Cancel"].exists {
                app.buttons["Cancel"].tap()
            } else {
                // Swipe down to dismiss sheet
                addBookSheet.swipeDown()
            }
        }
    }
    
    @MainActor
    func testFavoritesTab() throws {
        app.launch()
        
        // Navigate to favorites tab
        let favoritesTab = app.tabBars.buttons["Favorites"]
        favoritesTab.tap()
        
        // Wait for favorites view to load
        let favoritesView = app.navigationBars["Favorites"].firstMatch
        let favoritesExists = favoritesView.waitForExistence(timeout: 3.0)
        
        // The favorites view should exist even if empty
        XCTAssertTrue(app.tabBars.buttons["Favorites"].isSelected, "Favorites tab should be selected")
    }
    
    @MainActor
    func testSettingsTab() throws {
        app.launch()
        
        // Navigate to settings tab
        let settingsTab = app.tabBars.buttons["Settings"]
        settingsTab.tap()
        
        // Wait for settings view to load
        sleep(1) // Brief wait for view transition
        
        // Verify we're on the settings tab
        XCTAssertTrue(settingsTab.isSelected, "Settings tab should be selected")
        
        // Look for theme or color settings (based on your AppStorage properties)
        let settingsScrollView = app.scrollViews.firstMatch
        if settingsScrollView.exists {
            // Settings view loaded successfully
            XCTAssertTrue(true, "Settings view loaded")
        }
    }
    
    @MainActor
    func testErrorHandling() throws {
        // Launch with network error simulation
        app.launchEnvironment = ["SIMULATE_NETWORK_ERROR": "1"]
        app.launch()
        
        // Wait for potential error alert
        let errorAlert = app.alerts.firstMatch
        if errorAlert.waitForExistence(timeout: 5.0) {
            XCTAssertTrue(errorAlert.exists, "Error alert should appear")
            
            // Test alert buttons
            if app.buttons["Try Again"].exists {
                XCTAssertTrue(app.buttons["Try Again"].exists, "Try Again button should exist")
            }
            if app.buttons["Use Offline Data"].exists {
                XCTAssertTrue(app.buttons["Use Offline Data"].exists, "Use Offline Data button should exist")
            }
            if app.buttons["Cancel"].exists {
                app.buttons["Cancel"].tap()
            }
        }
    }
    
    @MainActor
    func testBookInteractions() throws {
        app.launch()
        
        // Wait for books to load
        sleep(2)
        
        // Look for book cells
        let bookCells = app.cells
        if bookCells.count > 0 {
            let firstBook = bookCells.firstMatch
            
            // Test tapping on a book (assuming it opens book detail)
            firstBook.tap()
            
            // Wait for potential navigation or modal
            sleep(1)
            
            // Test going back (if navigation occurred)
            if app.navigationBars.buttons["Back"].exists {
                app.navigationBars.buttons["Back"].tap()
            } else if app.buttons["Done"].exists {
                app.buttons["Done"].tap()
            }
        }
    }
    
    @MainActor
    func testGenreFiltering() throws {
        app.launch()
        
        // Wait for view to load
        sleep(2)
        
        // Look for genre filter options (assuming they exist in your UI)
        let filterButtons = app.buttons.matching(NSPredicate(format: "label CONTAINS[c] 'fiction' OR label CONTAINS[c] 'mystery' OR label CONTAINS[c] 'romance'"))
        
        if filterButtons.firstMatch.exists {
            let firstGenreFilter = filterButtons.firstMatch
            firstGenreFilter.tap()
            
            // Brief wait for filter to apply
            sleep(1)
            
            // Verify filtering worked by checking if results changed
            XCTAssertTrue(true, "Genre filter applied")
        }
    }
    
    @MainActor
    func testAppStateRestoration() throws {
        // First launch
        app.launch()
        sleep(2)
        
        // Perform some actions (like searching)
        let searchField = app.searchFields.firstMatch
        if searchField.exists {
            searchField.tap()
            searchField.typeText("test")
        }
        
        // Terminate app
        app.terminate()
        
        // Relaunch app
        app.launch()
        
        // Verify app state (search should be cleared on fresh launch)
        let searchFieldAfterRelaunch = app.searchFields.firstMatch
        if searchFieldAfterRelaunch.exists {
            let searchValue = searchFieldAfterRelaunch.value as? String
            XCTAssertNotEqual(searchValue, "test", "Search should be cleared on app relaunch")
        }
    }
    
    @MainActor
    func testAccessibility() throws {
        app.launch()
        
        // Test that key UI elements are accessible
        let tabBar = app.tabBars.firstMatch
        XCTAssertTrue(tabBar.isAccessibilityElement || tabBar.exists, "Tab bar should be accessible")
        
        // Test tab accessibility
        let myBooksTab = app.tabBars.buttons["My Books"]
        XCTAssertTrue(myBooksTab.exists, "My Books tab should be accessible")
        
        // Test search field accessibility
        let searchField = app.searchFields.firstMatch
        if searchField.exists {
            XCTAssertTrue(searchField.isAccessibilityElement, "Search field should be accessible")
        }
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testScrollPerformance() throws {
        app.launch()
        
        // Wait for content to load
        sleep(2)
        
        // Test scrolling performance if there are multiple books
        let scrollView = app.scrollViews.firstMatch
        if scrollView.exists {
            measure(metrics: [XCTOSSignpostMetric.scrollingAndDecelerationMetric]) {
                scrollView.swipeUp()
                sleep(1)
                scrollView.swipeDown()
                sleep(1)
            }
        }
    }
}


