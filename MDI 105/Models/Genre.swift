//
//  Genre.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//


enum Genre: String, CaseIterable, Codable, Hashable {
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
