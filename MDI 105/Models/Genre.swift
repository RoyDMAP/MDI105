//
//  Genre.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//


import SwiftUI
import Foundation

enum Genre: String, CaseIterable, Codable {
    case classic = "Classic"
    case fantasy = "Fantasy"
    case terror = "Terror"
    case dystopian = "Dystopian"
    case fiction = "Fiction"
    case nonFiction = "Non-Fiction"
    case mystery = "Mystery"
    case romance = "Romance"
    case sciFi = "Sci-Fi"
    case biography = "Biography"
    case history = "History"
}

