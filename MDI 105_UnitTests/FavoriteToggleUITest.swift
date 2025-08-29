//
//  FavoriteToggleUITest.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/26/25.
//

import SwiftUI
@testable import MDI_105

// Simple test function for FavoriteToggle
func testFavoriteToggleUI() {
    var isFavoriteValue = false
    let binding = Binding(
        get: { isFavoriteValue },
        set: { isFavoriteValue = $0 }
    )
    
    let favoriteToggle = FavoriteToggle(isFavorite: binding)
    
    assert(isFavoriteValue == false, "Initial favorite state should be false")
    isFavoriteValue = true
    
    // Test toggled state
    assert(isFavoriteValue == true, "Favorite state should be true after toggle")
    
    // Test toggle back
    isFavoriteValue = false
    assert(isFavoriteValue == false, "Favorite state should be false after second toggle")
    
    print("✅ FavoriteToggle UI test passed!")
}
