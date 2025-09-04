//
//  EditViewUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/3/25.
//

import XCTest

final class EditBookViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    //Helper methods
    private func navigateToEditView() {
        // Example navigation - adjust based on your app's structure
        // This might involve tapping a book item, then an edit button
        let firstBook = app.cells.firstMatch
        if firstBook.exists {
            firstBook.tap()
            
            // Look for edit button
            let editButton = app.buttons["Edit"]
            if editButton.exists {
                editButton.tap()
            } else {
                // navigation bar edit button
                let navEditButton = app.navigationBars.buttons["Edit"]
                if navEditButton.exists {
                    navEditButton.tap()
                }
            }
        }
    }

    //Basic form interaction tests
    func testEditBookFormFieldsExistAndEditable() throws {
        // Navigate to edit view
        navigateToEditView()
        
        // Wait for the form to appear
        var editBookForm = app.navigationBars["Edit Book"]
        if !editBookForm.exists {
            editBookForm = app.navigationBars.containing(.staticText, identifier: "Edit Book").firstMatch
        }
        
        XCTAssertTrue(editBookForm.waitForExistence(timeout: 5.0), "Edit Book navigation should exist")
        
        // Test Title field
        var titleField = app.textFields["Title"]
        if !titleField.exists {
            titleField = app.textFields.matching(identifier: "titleTextField").firstMatch
        }
        XCTAssertTrue(titleField.exists, "Title text field should exist")
        XCTAssertTrue(titleField.isHittable, "Title field should be interactive")
        
        // Test Author field
        var authorField = app.textFields["Author"]
        if !authorField.exists {
            authorField = app.textFields.matching(identifier: "authorTextField").firstMatch
        }
        XCTAssertTrue(authorField.exists, "Author text field should exist")
        XCTAssertTrue(authorField.isHittable, "Author field should be interactive")
        
        // Test Description field
        var descriptionField = app.textViews["Description"]
        if !descriptionField.exists {
            descriptionField = app.textFields["Description"]
        }
        if !descriptionField.exists {
            descriptionField = app.textViews.matching(identifier: "descriptionTextView").firstMatch
        }
        XCTAssertTrue(descriptionField.exists, "Description text field should exist")
        XCTAssertTrue(descriptionField.isHittable, "Description field should be interactive")
        
        // Test Review field - might also be a textView
        var reviewField = app.textViews["Your review"]
        if !reviewField.exists {
            reviewField = app.textFields["Your review"]
        }
        if !reviewField.exists {
            reviewField = app.textViews.matching(identifier: "reviewTextView").firstMatch
        }
        XCTAssertTrue(reviewField.exists, "Review text field should exist")
        XCTAssertTrue(reviewField.isHittable, "Review field should be interactive")
        
        // Test Image Name field
        var imageField = app.textFields["Image Name (optional)"]
        if !imageField.exists {
            imageField = app.textFields.matching(identifier: "imageNameTextField").firstMatch
        }
        XCTAssertTrue(imageField.exists, "Image name text field should exist")
    }
    
    func testEditBookTextFieldInput() throws {
        navigateToEditView()
        
        // Wait for form to load
        var titleField = app.textFields["Title"]
        if !titleField.exists {
            titleField = app.textFields.matching(identifier: "titleTextField").firstMatch
        }
        XCTAssertTrue(titleField.waitForExistence(timeout: 3.0), "Title field should exist")
        
        // Clear and enter new title
        titleField.tap()
        
        // Clear existing text
        if let currentText = titleField.value as? String, !currentText.isEmpty {
            // Select all and delete
            titleField.press(forDuration: 1.0)
            if app.menuItems["Select All"].exists {
                app.menuItems["Select All"].tap()
            }
            titleField.typeText(XCUIKeyboardKey.delete.rawValue)
        }
        
        titleField.typeText("New Test Title")
        
        // Verify the text was entered
        let titleValue = titleField.value as? String ?? ""
        XCTAssertTrue(titleValue.contains("New Test Title"), "Title should contain the entered text")
        
        // Test author field
        var authorField = app.textFields["Author"]
        if !authorField.exists {
            authorField = app.textFields.matching(identifier: "authorTextField").firstMatch
        }
        authorField.tap()
        
        // Clear existing text
        if let currentText = authorField.value as? String, !currentText.isEmpty {
            authorField.press(forDuration: 1.0)
            if app.menuItems["Select All"].exists {
                app.menuItems["Select All"].tap()
            }
            authorField.typeText(XCUIKeyboardKey.delete.rawValue)
        }
        
        authorField.typeText("Test Author Name")
        
        let authorValue = authorField.value as? String ?? ""
        XCTAssertTrue(authorValue.contains("Test Author Name"), "Author should contain the entered text")
        
        // Test description field
        var descriptionField = app.textViews["Description"]
        if !descriptionField.exists {
            descriptionField = app.textFields["Description"]
        }
        
        descriptionField.tap()
        
        // Clear existing text for textView
        if let currentText = descriptionField.value as? String, !currentText.isEmpty {
            descriptionField.press(forDuration: 1.0)
            if app.menuItems["Select All"].exists {
                app.menuItems["Select All"].tap()
            }
            descriptionField.typeText(XCUIKeyboardKey.delete.rawValue)
        }
        
        descriptionField.typeText("This is a test description for the book.")
        
        let descriptionValue = descriptionField.value as? String ?? ""
        XCTAssertTrue(descriptionValue.contains("test description"), "Description should contain entered text")
    }
    
    func testSaveEditedBook() throws {
        navigateToEditView()
        
        // Make some changes
        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3.0))
        
        titleField.tap()
        titleField.clearAndType(text: "Edited Title")
        
        // Find and tap save button
        var saveButton = app.buttons["Save"]
        if !saveButton.exists {
            saveButton = app.navigationBars.buttons["Save"]
        }
        if !saveButton.exists {
            saveButton = app.buttons["Done"]
        }
        
        XCTAssertTrue(saveButton.exists, "Save/Done button should exist")
        saveButton.tap()
        
        // Verify navigated away from edit view
        let editNavBar = app.navigationBars["Edit Book"]
        XCTAssertFalse(editNavBar.exists, "Should navigate away from edit view after saving")
    }
    
    func testCancelEditWithoutSaving() throws {
        navigateToEditView()
        
        // Make some changes
        let titleField = app.textFields["Title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 3.0))
        
        _ = titleField.value as? String ?? ""
        titleField.tap()
        titleField.clearAndType(text: "Should Not Save")
        
        // Find and tap cancel button
        var cancelButton = app.buttons["Cancel"]
        if !cancelButton.exists {
            cancelButton = app.navigationBars.buttons["Cancel"]
        }
        
        if cancelButton.exists {
            cancelButton.tap()
            
            // Handle potential alert
            if app.alerts.count > 0 {
                // If there's a "Discard Changes" alert, confirm
                let discardButton = app.alerts.buttons["Discard"]
                if discardButton.exists {
                    discardButton.tap()
                }
            }
        }
        
        // Navigate away from edit
        let editNavBar = app.navigationBars["Edit Book"]
        XCTAssertFalse(editNavBar.exists, "Should navigate away from edit view after canceling")
    }
}
//Test for extension
extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else {
            return
        }
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
    
    func clearAndType(text: String) {
        self.clearText()
        self.typeText(text)
    }
}
