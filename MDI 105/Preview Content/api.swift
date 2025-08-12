//
//  api.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import SwiftUI

func getBooks() -> [Book] {
    return [
        Book(
            title: "The Fellowship of the Ring",
            author: "J.R.R. Tolkien",
            image: "Pic1",
            description: "The first volume of The Lord of the Rings tells of the fateful power of the One Ring. It begins a magnificent tale of adventure that will plunge the members of the Fellowship of the Ring into a perilous quest and set the stage for the ultimate clash between the powers of good and evil.",
            rating: 4,
            review: "This is a great book",
            status: .finished
        ),
        Book(
            title: "The Two Towers",
            author: "J.R.R. Tolkien",
            image: "Pic2",
            description: "The second volume in The Lord of the Rings tells of the Fellowship's adventures as they continue their quest to destroy the Ring and defeat the Dark Lord Sauron. Frodo and Sam continue towards Mordor to destroy the Ring, unaware of the tragedy that has befallen their companions.",
            rating: 5,
            review: "Amazing book",
            status: .finished
        ),
        Book(
            title: "The Return of the King",
            author: "J.R.R. Tolkien",
            image: "Pic3",
            description: "The final volume of The Lord of the Rings, tells of the opposing strategies of the wizard Gandalf and the Dark Lord Sauron, the final battle, and the ending of the War of the Ring in the Battle of the Pelennor Fields and at the Black Gate.",
            rating: 5,
            review: "This is the best book",
            status: .finished
        )
    ]
}

#Preview {
    ContentView()
}
