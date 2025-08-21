//
//  constants.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/20/25.
//

let SETTINGS_THEME_KEY = "theme"
let GRID_COLUMN_NUMBER_KEY = "gridColumnNumber"
let SETTINGS_GRID_SHOW_AUTHOR_KEY = "gridShowAuthor"
let SETTINGS_APP_ACCENT_COLOR_KEY = "appAccentColor"

// i18n = internationalization

struct spanishConstants {
    static let welcomeTitle = "Bienvenido"
    static let welcomeSubtitle = "A MDI 105"
}

struct englishConstants {
    static let welcomeTitle = "Welcome"
    static let welcomeSubtitle = "Digital classic book library"
}

struct LanguageConstants{
    static let spanish = spanishConstants()
    static let english = englishConstants()
    
}

enum Language {
    case spanish
    case english
}

// Click [camera] to take a photo of the book cover.

// To take photo [camera] click
//instruction1 = "Click"
//emoji = [camera]
//instruction2 = "to take a photo of the book cover."

//"\(instruction1)  \(instruction2) \(emoji)"
