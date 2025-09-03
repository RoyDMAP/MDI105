//
//  constants.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/20/25.
//

let NEW_BOOK = Book(
    title: "",
    author: "",
    image: "",
    description: "",
    rating: 0,
    review: "",
    status: .notStarted,
    genre: .classic,
    isFavorite: false
)

let SETTINGS_THEME_KEY = "theme"
let GRID_COLUMN_NUMBER_KEY = "gridColumnNumber"
let SETTINGS_GRID_SHOW_AUTHOR_KEY = "gridShowAuthor"
let SETTINGS_APP_ACCENT_COLOR_KEY = "appAccentColor"

struct SpanishConstants {
    static let welcomeTitle = "Bienvenido"
    static let welcomeSubtitle = "A MDI 105"
}

struct EnglishConstants {
    static let welcomeTitle = "Welcome"
    static let welcomeSubtitle = "Digital classic book library"
}

struct LanguageConstants {
    static let spanish = SpanishConstants.self
    static let english = EnglishConstants.self
}

enum Language {
    case spanish
    case english
    
    var constants: any LanguageConstantsProtocol.Type {
        switch self {
        case .spanish:
            return SpanishConstants.self
        case .english:
            return EnglishConstants.self
        }
    }
}

protocol LanguageConstantsProtocol {
    static var welcomeTitle: String { get }
    static var welcomeSubtitle: String { get }
}

extension SpanishConstants: LanguageConstantsProtocol {}
extension EnglishConstants: LanguageConstantsProtocol {}

// Click [camera] to take a photo of the book cover.

// To take photo [camera] click
//instruction1 = "Click"
//emoji = [camera]
//instruction2 = "to take a photo of the book cover."

//"\(instruction1)  \(instruction2) \(emoji)"
