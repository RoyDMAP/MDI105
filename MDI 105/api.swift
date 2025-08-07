//
//  api.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import SwiftUI

func getItems() -> [Book] {
    return [
        Book(title: "The Fellowship of the Ring", image: "Pic1",
             description: "The first book in the trilogy"), 
        Book(title: "The Two Towers", image: "Pic2",
             description: "The second book in the trilogy"),
        Book(title: "The Return of the King", image: "Pic3",
             description: "The third book in the trilogy")
    ]
}
#Preview {
    ContentView()
}
